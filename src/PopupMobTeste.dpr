program PopupMobTeste;

uses
  System.StartUpCopy,
  FMX.Forms,
  uTeste in 'uTeste.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
