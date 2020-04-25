unit Task;

interface
uses
  Windows;
Type
  TTask = class
  private
    FPID: Integer;
    FName: String;
    FDescription: String;
    FMemory: Integer;
    FCPU: Integer;
    FLocal: String;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    property PID: Integer read FPID write FPID;
    property Name : String read FName write FName;
    property Description : String read FDescription write FDescription;
    property Memory : Integer read FMemory write FMemory;
    property CPU : Integer read FCPU write FCPU;
    property Local : String read FLocal write FLocal;

    procedure TrimMemory;
  published
    { published declarations }
end;
implementation

{ TTask }

procedure TTask.TrimMemory;
var 
  MainHandle : THandle;
begin
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, PID) ;
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
    CloseHandle(MainHandle) ;
  except
  end;
end;

end.


