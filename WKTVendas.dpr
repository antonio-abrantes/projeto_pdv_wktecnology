program WKTVendas;

uses
  Vcl.Forms,
  UPrincipal in 'fontes\UPrincipal.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'WKTVendas';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
