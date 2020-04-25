unit TrimMemoryDelphi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, TaskList, Task, Contnrs, Grids, XPMan,
  ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    edPID: TEdit;
    Label1: TLabel;
    bbAdd: TBitBtn;
    bbTrimMemoryList: TBitBtn;
    bbTrimMemoryAll: TBitBtn;
    sgTaskList: TStringGrid;
    XPManifest1: TXPManifest;
    StatusBar1: TStatusBar;
    pnTopo: TPanel;
    pnCentro: TPanel;
    pnBase: TPanel;
    TimerAttTaskList: TTimer;
    procedure bbAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TaskListToInterface;
    procedure bbTrimMemoryListClick(Sender: TObject);
    procedure sgTaskListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgTaskListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgTaskListDblClick(Sender: TObject);
    procedure TimerAttTaskListTimer(Sender: TObject);
    procedure bbTrimMemoryAllClick(Sender: TObject);
  private
    { Private declarations }
    procedure CreateTaskListGrid;
    procedure CheckGrid(Sender: TObject);
    procedure ManageTaskListByCheckOfGrid(Sender: TObject);
    procedure AddStringGridSelectedToTaskList(Sender: TObject);
    procedure RemoveStringGridSelectedToTaskList(Sender: TObject);
    function SelectedItemGridIsChecked(Sender: TObject):Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
var TaskList,TaskListClear:TTaskList;
const
  COL_CHECK = 0;
  COL_PID   = 1;
  COL_NAME  = 2;
  COL_DESCRIPTION = 3;
  COL_LOCAL = 4;

procedure TForm1.bbAddClick(Sender: TObject);
var Task:TTask;
begin
  Try
    Task := TTask.Create;
    Task.PID:=StrToIntDef(edPID.Text,GetCurrentProcessId);
    TaskList.Add(Task);
  Finally
    //TaskList.Free; se deixo o free aqui ele destroi o objeto inserido na lista 
  end;
  edPID.Clear;
  TaskListToInterface;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TaskList:=TTaskList.Create;
  TaskListClear:=TTaskList.Create;
  createTaskListGrid;
end;

procedure TForm1.TaskListToInterface;
var i:Integer;
begin
  sgTaskList.RowCount:=TaskList.Count;
  for i:=0 to TaskList.Count-1 do begin
    sgTaskList.Cells[COL_CHECK,i+1]:='';
    sgTaskList.Cells[COL_PID,i+1]:=IntToStr(TTask(TaskList.Items[i]).PID);
    sgTaskList.Cells[COL_NAME,i+1]:=TTask(TaskList.Items[i]).Name;
    sgTaskList.Cells[COL_DESCRIPTION,i+1]:=TTask(TaskList.Items[i]).Description;
    sgTaskList.Cells[COL_LOCAL,i+1]:=TTask(TaskList.Items[i]).Local;
    if(TaskList.InTaskList(TaskListClear))then CheckGrid(sgTaskList);
  end;
end;

procedure TForm1.bbTrimMemoryListClick(Sender: TObject);
begin
  TaskListClear.TrimMemory;
end;

procedure TForm1.createTaskListGrid;
begin
  sgTaskList.Cells[COL_CHECK,0]:='Clean?';
  sgTaskList.Cells[COL_PID,0]:='PID';
  sgTaskList.Cells[COL_NAME,0]:='Exe';
  sgTaskList.Cells[COL_DESCRIPTION,0]:='Name';
  sgTaskList.Cells[COL_LOCAL,0]:='Local';
  sgTaskList.ColWidths[COL_CHECK]:=36;
  sgTaskList.ColWidths[COL_PID]:=64;
  sgTaskList.ColWidths[COL_NAME]:=100;
  sgTaskList.ColWidths[COL_DESCRIPTION]:=120;
  sgTaskList.ColWidths[COL_LOCAL]:=300;
end;

procedure TForm1.sgTaskListDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  //http://www.planetadelphi.com.br/dica/7412/-checkbox-no-stringgrid-
  if (ACol = 0)and(ARow>0) Then begin
    if (SelectedItemGridIsChecked(Sender)) then
      DrawFrameControl((Sender as TStringGrid).Canvas.Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED) // Desenha o CheckBox desmarcado
    else
      DrawFrameControl((Sender as TStringGrid).Canvas.Handle, Rect,   DFC_BUTTON, DFCS_BUTTONCHECK); // Desenha o CheckBox marcado
  end;

end;

procedure TForm1.sgTaskListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //http://www.planetadelphi.com.br/dica/7412/-checkbox-no-stringgrid-
  case key of
    VK_SPACE : begin
      checkGrid(Sender);
      ManageTaskListByCheckOfGrid(Sender);
    end;
  end;
END;

procedure TForm1.checkGrid(Sender: TObject);
begin
  if((Sender as TStringGrid).Cells[COL_CHECK,(Sender as TStringGrid).Row] = '') then begin
    ((Sender as TStringGrid).Cells[COL_CHECK,(Sender as TStringGrid).Row] := 'OK')
  end else begin
    ((Sender as TStringGrid).Cells[COL_CHECK,(Sender as TStringGrid).Row] := '');
  end;
end;

procedure TForm1.sgTaskListDblClick(Sender: TObject);
begin
  checkGrid(Sender);
  ManageTaskListByCheckOfGrid(Sender);
end;

procedure TForm1.TimerAttTaskListTimer(Sender: TObject);
begin
  TimerAttTaskList.Enabled:=false;
  TaskList.LoadFromWindowsProcess;
  TaskListToInterface;
  TimerAttTaskList.Enabled:=True;
end;

procedure TForm1.AddStringGridSelectedToTaskList(Sender: TObject);
var Task:TTask;
begin
  Task := TTask.Create;
  Task.PID:=StrToInt((Sender as TStringGrid).Cells[COL_PID,(Sender as TStringGrid).Row]);
  Task.Name:=(Sender as TStringGrid).Cells[COL_NAME,(Sender as TStringGrid).Row];
  Task.Description:=(Sender as TStringGrid).Cells[COL_DESCRIPTION,(Sender as TStringGrid).Row];
  Task.Local:=(Sender as TStringGrid).Cells[COL_LOCAL,(Sender as TStringGrid).Row];
  TaskListClear.Add(Task)
end;

procedure TForm1.ManageTaskListByCheckOfGrid(Sender: TObject);
begin
  if(SelectedItemGridIsChecked(Sender))then begin
    AddStringGridSelectedToTaskList(Sender);
  end else begin
    RemoveStringGridSelectedToTaskList(Sender);
  end;
end;

function TForm1.SelectedItemGridIsChecked(Sender: TObject): Boolean;
begin
  Result := (Sender as TStringGrid).Cells[0,(Sender as TStringGrid).Row] = 'OK';
end;

procedure TForm1.RemoveStringGridSelectedToTaskList(Sender: TObject);
begin
  ShowMessage('Remoção da lista não implementada')
end;

procedure TForm1.bbTrimMemoryAllClick(Sender: TObject);
begin
  TaskList.TrimMemory;
end;

end.
