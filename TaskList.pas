unit TaskList;
interface
  uses Classes, Task, Dialogs, Contnrs, TLHelp32, PsAPI, Windows;
Type
  TTaskList = class(TObjectList)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function RemoveByIndex(Index:Integer):Boolean;
    function getTaskByIndex(Index:Integer):TTask;
    procedure TrimMemory;
    procedure LoadFromWindowsProcess;
    procedure ClearList;
    function InTaskList(TaskList:TTaskList):Boolean;
  published
  { published declarations }
end;

implementation
{ TListaCliente }

procedure TTaskList.ClearList;
begin
  While Self.Count>0 do Self.Delete(0);
end;

function TTaskList.getTaskByIndex(Index: Integer): TTask;
begin
  if Self.Count > 0 then
    Result := TTask(Self.Items[Index]);
end;

function TTaskList.InTaskList(TaskList: TTaskList): Boolean;
var ITERATOR_LIST,ITERATOR_SELF:Integer;
begin
  result:=False;
  for ITERATOR_LIST:=0 to TaskList.Count-1 do begin
    for ITERATOR_SELF:=0 to Self.Count-1 do begin
      if(TTask(TaskList.Items[ITERATOR_LIST]).PID=TTask(Self.Items[ITERATOR_SELF]).PID)then begin
        result:=True;
        Break;
      end;
    end;
    if(Result)then Break;
  end;
end;

procedure TTaskList.LoadFromWindowsProcess;
var
  ProcEntry: TProcessEntry32;
  Hnd: THandle;
  Fnd: Boolean;
  Task : TTask;
begin
  ClearList;
  Hnd := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  if Hnd<>-1 then
  begin
    ProcEntry.dwSize := SizeOf(TProcessEntry32);
    Fnd := Process32First(Hnd, ProcEntry);
    while Fnd do
    begin
      Task := TTask.Create;
      Task.PID:=ProcEntry.th32ProcessID;
      Task.Name:=ProcEntry.szExeFile;
      Task.Description:=ProcEntry.szExeFile;
      Task.Local:=ProcEntry.szExeFile;
      Self.Add(Task);
      Fnd := Process32Next(Hnd, ProcEntry);
    end;
    CloseHandle(Hnd);
  end;
end;

function TTaskList.RemoveByIndex(Index: Integer): Boolean;
begin
  Result:=Index < Count;

  if(Result)then begin
    Self.Delete(Index)
  end;
end;

procedure TTaskList.TrimMemory;
var i:Integer;
begin
  for i:=0 to Self.Count-1 do begin
    TTask(Self[i]).TrimMemory;
  end;
end;

end.


