unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  System.ImageList, Vcl.ImgList, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Samples.Spin, Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, UPedido, UItemPedido, Datasnap.Provider;

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
    shapeSatatusCaixa: TShape;
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
    Label11: TLabel;
    lbPedido: TLabel;
    QGeraPedidoCOUNT: TLargeintField;
    procedure editCodProdutoChange(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spnQuantidadeChange(Sender: TObject);
    procedure editCodClienteChange(Sender: TObject);
    procedure btnFinalizarVendaClick(Sender: TObject);
    procedure btnIniciarVendaClick(Sender: TObject);
    procedure btnCancelarVendaClick(Sender: TObject);
    procedure grdVendasKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdVendasColEnter(Sender: TObject);
    procedure grdVendasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
    procedure DesabilitaCampos;
    procedure HabilitaCampos;
    procedure LimpaCampos;
    procedure SetaCamposDBGrid;
    procedure AtualizaTotalItem;
    procedure limpaDataSetPedido;
    procedure GeraCodigoPedido;
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
        ParamByName('1').Value := Pedido.NUM_PEDIDO;
        ParamByName('2').Value := editCodCliente.Text;
        ParamByName('3').Value := cdsitensVendasTotal.Value;
        ExecSQL;

        cdsitensVendas.First;

        while not cdsitensVendas.Eof do
        begin
          item := TItemPedido.Create;
          item.NUM_PEDIDO := Pedido.NUM_PEDIDO;
          item.CODIGO_PRODUTO := cdsitensVendascod.Value;
          item.QUANTIDADE := cdsitensVendasqtd.Value;
          item.VLR_UNITARIO := cdsitensVendasvl_item.Value;
          item.VLR_TOTAL := cdsitensVendasTotal_Item.Value;
          IncluiItemVenda(item);
          cdsitensVendas.Next;
          FreeAndNil(item);
        end;
      end;

      limpaDataSetPedido;

      DesabilitaCampos;

      lbStatusCaixa.Caption := 'CAIXA LIVRE';
      shapeSatatusCaixa.Brush.Color := $0000DD00;
      lbPedido.Caption := '00000';
      editCodCliente.Text := '';
      editNomeCliente.Text := '';
      LimpaCampos;

      Application.MessageBox('Pedido realizado com sucesso!', 'Informação', mb_ok + MB_ICONINFORMATION);
   end else
   begin
     Application.MessageBox('Sem pedido para processar!','Teste', MB_OK+MB_ICONERROR);
   end;
   FreeAndNil(Pedido);
   LimpaCampos;
end;

function TfrmPrincipal.IncluiItemVenda(ItemPedido : TItemPedido): Boolean;
begin
  try
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

    Result := true;
  except
    on e: exception do
    begin
      Result := false;
    end;
  end;
end;

procedure TfrmPrincipal.btnIniciarVendaClick(Sender: TObject);
begin
  lbStatusCaixa.Caption := 'OCUPADO';
  shapeSatatusCaixa.Brush.Color := $004949FC;
  cds_itensVendas.DataSet.Open;
  btnIniciarVenda.Enabled := False;

  HabilitaCampos;

  FreeAndNil(Pedido);
  GeraCodigoPedido;
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
     LimpaCampos;
  end;


end;

procedure TfrmPrincipal.btnCancelarVendaClick(Sender: TObject);
begin
  if MessageDlg('Deseja cancelar a venda?',mtConfirmation,[mbYes,mbNo],0)=mrYes
   then begin
      FreeAndNil(Pedido);
      limpaDataSetPedido;
      btnFinalizarVenda.Enabled := False;
      lbStatusCaixa.Caption := 'CAIXA LIVRE';
      shapeSatatusCaixa.Brush.Color := $0000DD00;
      DesabilitaCampos;
      lbPedido.Caption := '00000';
      editCodCliente.Text := '';
      editNomeCliente.Text := '';
      LimpaCampos;
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
begin
//  Application.MessageBox('Teste '+IntToStr(item.NUM_PEDIDO),'Produto não encontrado', MB_OK+MB_ICONERROR);
  cdsitensVendas.CreateDataSet;
  DesabilitaCampos;
end;

procedure TfrmPrincipal.GeraCodigoPedido;
begin
  Pedido := TPedido.Create;
  with QGeraPedido do
  begin
    Close;
    Open;
    FetchAll;

    Pedido.NUM_PEDIDO :=  QGeraPedidoCount.Value + 1;

    lbPedido.Caption := Format('%5.5d', [Pedido.NUM_PEDIDO]);
  end;
end;

procedure TfrmPrincipal.grdVendasColEnter(Sender: TObject);
begin
  SetaCamposDBGrid;
end;


procedure TfrmPrincipal.grdVendasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 i: Integer;
begin
  if key = vk_delete then
  begin
  if cdsitensVendas.State in [dsBrowse] then
  begin
    if MessageDlg('Deseja excluir o registro?', mtConfirmation, mbYesNo, 0) = mrYes then
    begin
        cds_itensVendas.DataSet.Delete;
    end;
  end;
end;
end;

procedure TfrmPrincipal.grdVendasKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SetaCamposDBGrid;
end;


procedure TfrmPrincipal.HabilitaCampos;
begin
  editCodCliente.Enabled := True;
  editNomeCliente.Enabled := True;
  editCodProduto.Enabled := True;
  editPrecoUnitario.Enabled := True;
  editPrecoTotalItem.Enabled := True;
  spnQuantidade.Enabled := True;
  btnAdicionarProduto.Enabled := True;
  btnCancelarVenda.Enabled := True;
  btnFinalizarVenda.Enabled := True;
  btnIniciarVenda.Enabled := False;
end;

procedure TfrmPrincipal.DesabilitaCampos;
begin
  LimpaCampos;
  editCodProduto.Enabled := False;
  editCodCliente.Enabled := False;
  editNomeCliente.Enabled := False;
  editPrecoUnitario.Enabled := False;
  editPrecoTotalItem.Enabled := False;
  spnQuantidade.Enabled := False;
  btnAdicionarProduto.Enabled := False;
  btnFinalizarVenda.Enabled := False;
  btnCancelarVenda.Enabled := False;
  btnIniciarVenda.Enabled := True;
end;

procedure TfrmPrincipal.spnQuantidadeChange(Sender: TObject);
begin
  AtualizaTotalItem;
end;

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
  editCodProduto.Text := '';
  editPrecoUnitario.Clear;
  editPrecoTotalItem.Clear;
end;

procedure TfrmPrincipal.limpaDataSetPedido;
begin
    with cdsitensVendas do
    begin
      Open;
      EmptyDataSet;
      Close;
    end;
    cdsitensVendas.Open;
end;

procedure TfrmPrincipal.SetaCamposDBGrid;
begin
   editCodProduto.Text := cdsitensVendascod.AsString;
   spnQuantidade.Value := cdsitensVendasqtd.Value;
   AtualizaTotalItem;
end;

procedure TfrmPrincipal.AtualizaTotalItem;
begin
  if((spnQuantidade.Value > 0) and (editPrecoUnitario.Text <> '')) then
  begin
     editPrecoTotalItem.Text := formatfloat( '##,###,##0.00', QProdutosPRECO_VENDA.Value * spnQuantidade.Value);
  end;
end;



end.
