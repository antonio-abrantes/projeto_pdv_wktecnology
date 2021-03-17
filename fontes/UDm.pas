unit UDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDmDados = class(TDataModule)
    Conexao: TFDConnection;
    DriverMySQL: TFDPhysMySQLDriverLink;
    tb_clientes: TFDTable;
    tb_clientescodigo: TFDAutoIncField;
    tb_clientesnome: TStringField;
    tb_clientescidade: TStringField;
    tb_clientesuf: TStringField;
    Dts_clientes: TDataSource;
    tb_pedidos_dados_gerais: TFDTable;
    tb_produtos: TFDTable;
    tb_pedidos_produtos: TFDTable;
    Dts_produtos: TDataSource;
    Dts_pedidos_dados_gerais: TDataSource;
    Dts_pedidos_produtos: TDataSource;
    FDTransaction1: TFDTransaction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmDados: TDmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
