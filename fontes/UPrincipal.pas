unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  System.ImageList, Vcl.ImgList, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Samples.Spin, Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, UPedido, UItemPedido;

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
    lbProduto: TLabel;
    Shape13: TShape;
    lbTotalPedido: TLabel;
    editCodCliente: TEdit;
    editNomeCliente: TEdit;
    editCodProduto: TEdit;
    spnQuantidade: TSpinEdit;
    editPrecoTotalItem: TEdit;
    Shape14: TShape;
    lbStatusCaixa: TLabel;
    cdsitensVendas: TClientDataSet;
    cdsitensVendascod: TIntegerField;
    cdsitensVendasdescricao: TStringField;
    cdsitensVendasvl_item: TCurrencyField;
    cdsitensVendasTotal_Item: TCurrencyField;
    cdsitensVendasvl_unitario: TCurrencyField;
    cdsitensVendasTotal: TAggregateField;
    cds_itensVendas: TDataSource;
    grdVendas: TDBGrid;
    QProdutos: TFDQuery;
    QProdutosCODIGO: TFDAutoIncField;
    QProdutosDESCRICAO: TStringField;
    QProdutosPRECO_VENDA: TBCDField;
    editPrecoUnitario: TEdit;
    QClientes: TFDQuery;
    QClientesCODIGO: TFDAutoIncField;
    QClientesNOME: TStringField;
    QClientesCIDADE: TStringField;
    QClientesUF: TStringField;
    QFechaPedido: TFDQuery;
    QItemVenda: TFDQuery;
    cdsitensVendasqtd: TIntegerField;
    QGeraPedido: TFDQuery;
    procedure editCodProdutoChange(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spnQuantidadeChange(Sender: TObject);
    procedure editCodClienteChange(Sender: TObject);
    procedure btnFinalizarVendaClick(Sender: TObject);
    procedure btnIniciarVendaClick(Sender: TObject);

  private
    { Private declarations }
    procedure IniciaVenda;
    procedure LimpaCampos;
    procedure AtualizaTotalItem;
    function ValidaCampos: Boolean;
    function IncluiItemVenda(ItemPedido : TItemPedido): Boolean;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  Pedido : TPedido;

implementation

uses
  UDm;

{$R *.dfm}

function TfrmPrincipal.IncluiItemVenda(ItemPedido : TItemPedido): Boolean;
begin
  //Implementar item de venda no fechamento
  with QItemVenda do
  begin
    Close;
    ParamByName('1').Value := ItemPedido.NUM_PEDIDO;
    ParamByName('2').Value := ItemPedido.CODIGO_PRODUTO;
    ParamByName('3').Value := ItemPedido.QUANTIDADE;
    ParamByName('4').Value := ItemPedido.VLR_UNITARIO;
    ParamByName('5').Value := ItemPedido.VLR_TOTAL;
    ExecSQL;
  end;

end;

procedure TfrmPrincipal.btnFinalizarVendaClick(Sender: TObject);
var
  item:   TItemPedido;
begin
  //Implementar
   if(grdVendas.DataSource.DataSet.RecordCount <> 0) then
   begin
      with QFechaPedido do
      begin
        Close;
        ParamByName('2').Value := editCodCliente.Text;
        ParamByName('3').Value := cdsitensVendasTotal.Value;
        ExecSQL;

        DmDados.FDTransaction1.CommitRetaining;

        cdsitensVendas.First;

        while not cdsitensVendas.Eof do
        begin
          item := TItemPedido.Create;
          item.NUM_PEDIDO := 1;
          item.CODIGO_PRODUTO := cdsitensVendascod.Value;
          item.QUANTIDADE := cdsitensVendasqtd.Value;
          item.VLR_UNITARIO := cdsitensVendasvl_item.Value;
          item.VLR_TOTAL := cdsitensVendasTotal_Item.Value;
          IncluiItemVenda(item);
        end;

      end;
   end else
   begin
     Application.MessageBox('Sem pedido para processar!','Teste', MB_OK+MB_ICONERROR);
   end;
   FreeAndNil(item);
end;

procedure TfrmPrincipal.btnIniciarVendaClick(Sender: TObject);
begin
  //Implementar inicio do pedido
  Pedido := TPedido.Create;



end;

procedure TfrmPrincipal.btnAdicionarProdutoClick(Sender: TObject);
begin
  try
      if (ValidaCampos = True) then
      begin
        cdsitensVendas.Append;
        cdsitensVendascod.Value := QProdutosCODIGO.Value;
        cdsitensVendasdescricao.Value := QProdutosDESCRICAO.Value;
        cdsitensVendasqtd.Value := spnQuantidade.Value;
        cdsitensVendasvl_item.Value := QProdutosPRECO_VENDA.Value;
        cdsitensVendasTotal_Item.Value := QProdutosPRECO_VENDA.Value *  spnQuantidade.Value;
        cdsitensVendas.Post;

        lbTotalPedido.Caption := formatfloat( '##,###,##0.00', cdsitensVendasTotal.Value);

        editCodProduto.SetFocus;
      end else
      begin
         Application.MessageBox('Preencha os dados do produto!','Campos inválidos', MB_OK+MB_ICONERROR);
      end;

  finally
      //Implementar
  end;


end;

procedure TfrmPrincipal.editCodClienteChange(Sender: TObject);
begin
    if(editCodCliente.Text <> '') then
    begin
        with QClientes do
        begin
            Close;
            ParamByName('cod').Value := editCodCliente.Text;
            Open;
            FetchAll;
        end;
        if (QClientes.RecordCount > 0) then
        begin
            editNomeCliente.Text := QClientesNOME.Value;
        end
        else
        begin
            editNomeCliente.Text := 'CLIENTE NÃO CADASTRADO...'
        end;
//      Application.MessageBox('Você deve informar um produto que exista no estoque!','Produto não encontrado', MB_OK+MB_ICONERROR);
    end
    else
    begin
        LimpaCampos;
    end;
end;

procedure TfrmPrincipal.editCodProdutoChange(Sender: TObject);
begin
    if(editCodProduto.Text <> '') then
    begin
        with QProdutos do
        begin
            Close;
            ParamByName('cod').Value := editCodProduto.Text;
            Open;
            FetchAll;
        end;
        if (QProdutos.RecordCount > 0) then
        begin
            spnQuantidade.Value := 0;
            lbProduto.Caption := QProdutosDESCRICAO.AsString;
            editPrecoUnitario.Text := formatfloat( '##,###,##0.00', QProdutosPRECO_VENDA.AsString.ToDouble);
            AtualizaTotalItem;
        end
        else
        begin
            LimpaCampos;
            LBpRODUTO.Caption := 'PRODUTO NÃO ENCONTRADO...'
        end;
//      Application.MessageBox('Você deve informar um produto que exista no estoque!','Produto não encontrado', MB_OK+MB_ICONERROR);
    end
    else
    begin
        LimpaCampos;
    end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  item:   TItemPedido;
  teste: Integer;
begin
  item := TItemPedido.Create;
  item.NUM_PEDIDO := 25;
  teste := item.NUM_PEDIDO;
//  Application.MessageBox('Teste '+IntToStr(item.NUM_PEDIDO),'Produto não encontrado', MB_OK+MB_ICONERROR);
  cdsitensVendas.CreateDataSet;

  FreeAndNil(item);
end;


procedure TfrmPrincipal.IniciaVenda;
begin
  // Implementar
end;

procedure TfrmPrincipal.spnQuantidadeChange(Sender: TObject);
begin
  AtualizaTotalItem;
end;

// label8.Caption := Format('%5.5d', [spCodVenda.Value]); // resulta '00123' 5 Dígitos;
// EdtTotal.Text := FormatFloat('###,###,##0.00', TrataValor(EdtTotal.Text));
// Application.MessageBox('Teste!','Teste', MB_OK+MB_ICONERROR);

function TfrmPrincipal.ValidaCampos: Boolean;
begin
    if(editCodProduto.Text = '')
      or (editCodProduto.GetTextLen < 1)
        or (spnQuantidade.Value = 0)
          or (editPrecoUnitario.Text = '') then
    begin
      Result := False;
    end else
    begin
      Result := True;
    end;
end;

procedure TfrmPrincipal.LimpaCampos;
begin
  spnQuantidade.Value := 0;
  editPrecoUnitario.Clear;
  editPrecoTotalItem.Clear;
end;

procedure TfrmPrincipal.AtualizaTotalItem;
begin
  if((spnQuantidade.Value > 0) and (editPrecoUnitario.Text <> '')) then
  begin
     editPrecoTotalItem.Text := formatfloat( '##,###,##0.00', QProdutosPRECO_VENDA.Value * spnQuantidade.Value);
  end;
end;

end.
