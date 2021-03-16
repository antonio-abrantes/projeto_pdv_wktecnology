program WKTVendas;

uses
  Vcl.Forms,
  UPrincipal in 'fontes\UPrincipal.pas' {frmPrincipal},
  UDm in 'fontes\UDm.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'WKTVendas';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
