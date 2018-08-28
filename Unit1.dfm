object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Beeline Internet Brute&Checker'
  ClientHeight = 400
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 3
    Width = 185
    Height = 24
    Caption = 'Main Panel'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 26
    Width = 185
    Height = 106
    TabOrder = 1
    object Button1: TButton
      Left = 8
      Top = 7
      Width = 169
      Height = 25
      Caption = 'Add Account List'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 38
      Width = 169
      Height = 25
      Caption = 'Start'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 96
      Top = 69
      Width = 81
      Height = 25
      Caption = 'Stop'
      Enabled = False
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 8
      Top = 69
      Width = 82
      Height = 25
      Caption = 'Pause'
      Enabled = False
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object Panel3: TPanel
    Left = 191
    Top = 3
    Width = 185
    Height = 29
    Caption = 'All Statistic'
    TabOrder = 2
  end
  object Panel4: TPanel
    Left = 191
    Top = 26
    Width = 185
    Height = 106
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 81
      Height = 13
      Caption = 'All Accounts List:'
    end
    object Label2: TLabel
      Left = 8
      Top = 26
      Width = 76
      Height = 13
      Caption = 'Good Accounts:'
    end
    object Label3: TLabel
      Left = 8
      Top = 46
      Width = 69
      Height = 13
      Caption = 'Bad Accounts:'
    end
    object Label4: TLabel
      Left = 8
      Top = 85
      Width = 33
      Height = 13
      Caption = 'Errors:'
    end
    object AllAccount: TLabel
      Left = 168
      Top = 8
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
      WordWrap = True
    end
    object GoodLabel: TLabel
      Left = 168
      Top = 26
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object ErrorLabel: TLabel
      Left = 168
      Top = 85
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object BadLabel: TLabel
      Left = 168
      Top = 46
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object Label5: TLabel
      Left = 8
      Top = 65
      Width = 39
      Height = 13
      Caption = 'ReBrute'
    end
    object ReBruteLabel: TLabel
      Left = 168
      Top = 65
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 138
    Width = 567
    Height = 26
    Caption = 'Log'
    TabOrder = 4
  end
  object Panel6: TPanel
    Left = 0
    Top = 161
    Width = 567
    Height = 239
    TabOrder = 5
    object ListView1: TListView
      Left = 14
      Top = 9
      Width = 553
      Height = 184
      ParentCustomHint = False
      Columns = <
        item
          Caption = 'Login'
          Width = 100
        end
        item
          Caption = 'Password'
          Width = 110
        end
        item
          Caption = 'Money'
          Width = 95
        end
        item
          AutoSize = True
          Caption = 'Owner'
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      FullDrag = True
      GridLines = True
      HotTrack = True
      MultiSelect = True
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
    end
    object Panel7: TPanel
      Left = 8
      Top = 199
      Width = 553
      Height = 34
      TabOrder = 1
      object Gauge1: TGauge
        Left = 8
        Top = 8
        Width = 537
        Height = 20
        Progress = 0
      end
    end
  end
  object Panel8: TPanel
    Left = 382
    Top = 0
    Width = 185
    Height = 29
    Caption = 'Settings'
    TabOrder = 6
  end
  object Panel9: TPanel
    Left = 382
    Top = 23
    Width = 185
    Height = 109
    TabOrder = 7
    object Label9: TLabel
      Left = 8
      Top = 15
      Width = 38
      Height = 13
      Caption = 'Thread:'
    end
    object Label10: TLabel
      Left = 8
      Top = 40
      Width = 42
      Height = 13
      Caption = 'Timeout:'
    end
    object Thread1: TSpinEdit
      Left = 80
      Top = 12
      Width = 97
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 10
    end
    object TimeOut: TSpinEdit
      Left = 80
      Top = 40
      Width = 97
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 10000
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 68
      Width = 117
      Height = 17
      Caption = 'Create ReBrute File'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 2
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 88
      Width = 157
      Height = 17
      Caption = 'One User-Agent [BETA TEST]'
      Enabled = False
      TabOrder = 3
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Txt File|*.txt'
    Left = 256
    Top = 265
  end
end
