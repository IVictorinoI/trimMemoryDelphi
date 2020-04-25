object Form1: TForm1
  Left = 367
  Top = 187
  Width = 742
  Height = 359
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 301
    Width = 726
    Height = 19
    Panels = <>
  end
  object pnTopo: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 57
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 34
      Height = 13
      Caption = 'Search'
    end
    object edPID: TEdit
      Left = 24
      Top = 28
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object bbAdd: TBitBtn
      Left = 151
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Search'
      TabOrder = 1
      OnClick = bbAddClick
    end
  end
  object pnCentro: TPanel
    Left = 0
    Top = 57
    Width = 726
    Height = 171
    Align = alClient
    TabOrder = 2
    object sgTaskList: TStringGrid
      Left = 1
      Top = 1
      Width = 724
      Height = 169
      Align = alClient
      FixedCols = 0
      RowCount = 2
      TabOrder = 0
      OnDblClick = sgTaskListDblClick
      OnDrawCell = sgTaskListDrawCell
      OnKeyDown = sgTaskListKeyDown
      RowHeights = (
        24
        24)
    end
  end
  object pnBase: TPanel
    Left = 0
    Top = 228
    Width = 726
    Height = 73
    Align = alBottom
    TabOrder = 3
    DesignSize = (
      726
      73)
    object bbTrimMemoryList: TBitBtn
      Left = 10
      Top = 8
      Width = 710
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Trim Memory List'
      TabOrder = 0
      OnClick = bbTrimMemoryListClick
    end
    object bbTrimMemoryAll: TBitBtn
      Left = 10
      Top = 40
      Width = 710
      Height = 25
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Trim Memory All'
      TabOrder = 1
      OnClick = bbTrimMemoryAllClick
    end
  end
  object XPManifest1: TXPManifest
    Left = 352
    Top = 160
  end
  object TimerAttTaskList: TTimer
    OnTimer = TimerAttTaskListTimer
    Left = 328
    Top = 24
  end
end
