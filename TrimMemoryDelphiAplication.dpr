program TrimMemoryDelphiAplication;

uses
  Forms,
  TrimMemoryDelphi in 'TrimMemoryDelphi.pas' {Form1},
  Task in 'Task.pas',
  TaskList in 'TaskList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
