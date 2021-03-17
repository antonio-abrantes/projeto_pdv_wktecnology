object DmDados: TDmDados
  OldCreateOrder = False
  Height = 533
  Width = 695
  object Conexao: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Server=localhost'
      'Database=wktec_dados'
      'DriverID=MySQL')
    TxOptions.Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Connected = True
    LoginPrompt = False
    Left = 576
    Top = 16
  end
  object DriverMySQL: TFDPhysMySQLDriverLink
    VendorLib = 'E:\Projetos\WKTecnology_Vendas\libmysql.dll'
    Left = 640
    Top = 16
  end
  object tb_clientes: TFDTable
    IndexFieldNames = 'codigo'
    Connection = Conexao
    UpdateOptions.UpdateTableName = 'wktec_dados.clientes'
    TableName = 'wktec_dados.clientes'
    Left = 24
    Top = 24
    object tb_clientescodigo: TFDAutoIncField
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object tb_clientesnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 255
    end
    object tb_clientescidade: TStringField
      FieldName = 'cidade'
      Origin = 'cidade'
      Required = True
      Size = 255
    end
    object tb_clientesuf: TStringField
      FieldName = 'uf'
      Origin = 'uf'
      Required = True
      Size = 2
    end
  end
  object Dts_clientes: TDataSource
    DataSet = tb_clientes
    Left = 96
    Top = 24
  end
  object tb_pedidos_dados_gerais: TFDTable
    Connection = Conexao
    UpdateOptions.UpdateTableName = 'wktec_dados.pedidos_dados_gerais'
    TableName = 'wktec_dados.pedidos_dados_gerais'
    Left = 64
    Top = 184
  end
  object tb_produtos: TFDTable
    Connection = Conexao
    UpdateOptions.UpdateTableName = 'wktec_dados.produtos'
    TableName = 'wktec_dados.produtos'
    Left = 32
    Top = 104
  end
  object tb_pedidos_produtos: TFDTable
    Connection = Conexao
    UpdateOptions.UpdateTableName = 'wktec_dados.produtos'
    TableName = 'wktec_dados.produtos'
    Left = 54
    Top = 256
  end
  object Dts_produtos: TDataSource
    DataSet = tb_produtos
    Left = 112
    Top = 104
  end
  object Dts_pedidos_dados_gerais: TDataSource
    DataSet = tb_pedidos_dados_gerais
    Left = 208
    Top = 184
  end
  object Dts_pedidos_produtos: TDataSource
    DataSet = tb_pedidos_produtos
    Left = 176
    Top = 256
  end
  object FDTransaction1: TFDTransaction
    Options.Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Connection = Conexao
    Left = 608
    Top = 72
  end
end
