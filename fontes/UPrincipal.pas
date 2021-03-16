unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  System.ImageList, Vcl.ImgList, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Samples.Spin;

type
  TfrmPrincipal = class(TForm)
    Shape1: TShape;
    btnIniciarVenda: TSpeedButton;
    btnFinalizarVenda: TSpeedButton;
    btnCancelarVenda: TSpeedButton;
    Shape2: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Label3: TLabel;
    Shape7: TShape;
    Shape8: TShape;
    Label4: TLabel;
    Shape9: TShape;
    Label5: TLabel;
    Label6: TLabel;
    btnAdicionarProduto: TSpeedButton;
    Shape11: TShape;
    Shape12: TShape;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Shape10: TShape;
    Label10: TLabel;
    Label11: TLabel;
    Shape13: TShape;
    Label12: TLabel;
    grdVendas: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    SpinEdit1: TSpinEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Shape14: TShape;
    lbStatusCaixa: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

end.
