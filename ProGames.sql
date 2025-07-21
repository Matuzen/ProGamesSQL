CREATE DATABASE ProGames;
GO

USE ProGames;
GO


-- Tipo de movimentação de estoque
CREATE TABLE TipoMovimentacaoEstoque (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Nome NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_TipoMovimentacaoEstoque PRIMARY KEY (Id)
);
GO

-- Tabela de Usuários
CREATE TABLE Usuario (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL, 
    Senha NVARCHAR(255) NOT NULL,
    Ativo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Usuario PRIMARY KEY (Id)
);
GO

-- Fabricantes de plataformas
CREATE TABLE FabricantePlataforma (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Nome NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_FabricantePlataforma PRIMARY KEY (Id)
);
GO

-- Gêneros de jogos
CREATE TABLE GeneroJogo (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Nome NVARCHAR(50) NOT NULL,
    Descricao NVARCHAR(150),
    CONSTRAINT PK_GeneroJogo PRIMARY KEY (Id)
);
GO

-- Clientes
CREATE TABLE Cliente (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    NomeCompleto NVARCHAR(100) NOT NULL,
    CPF_CNPJ NVARCHAR(20) UNIQUE NOT NULL,
    Ativo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Cliente PRIMARY KEY (Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Cliente_CPF_CNPJ ON Cliente(CPF_CNPJ);
GO

-- Contatos
CREATE TABLE Contato (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    ClienteId UNIQUEIDENTIFIER NOT NULL,
    Telefone NVARCHAR(20),
    Email NVARCHAR(100),
    CONSTRAINT PK_Contato PRIMARY KEY (Id),
    CONSTRAINT FK_Contato_Cliente FOREIGN KEY (ClienteId) REFERENCES Cliente(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Contato_ClienteId ON Contato(ClienteId);
CREATE NONCLUSTERED INDEX IDX_Contato_Email ON Contato(Email);
GO

-- Endereço dos clientes
CREATE TABLE EnderecoCliente (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    ClienteId UNIQUEIDENTIFIER NOT NULL,
    Rua NVARCHAR(100) NOT NULL,
    Numero NVARCHAR(20) NOT NULL,
    Complemento NVARCHAR(100),
    Bairro NVARCHAR(50) NOT NULL,
    Cidade NVARCHAR(50) NOT NULL,
    Estado NVARCHAR(50) NOT NULL,
    Cep NVARCHAR(9) NOT NULL,
    CONSTRAINT PK_EnderecoCliente PRIMARY KEY (Id),
    CONSTRAINT FK_EnderecoCliente_Cliente FOREIGN KEY (ClienteId) REFERENCES Cliente(Id)
);
GO

-- Plataformas
CREATE TABLE Plataforma (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Nome NVARCHAR(100) NOT NULL,
    FabricanteId UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_Plataforma PRIMARY KEY (Id),
    CONSTRAINT FK_Plataforma_Fabricante FOREIGN KEY (FabricanteId) REFERENCES FabricantePlataforma(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Plataforma_FabricanteId ON Plataforma(FabricanteId);
GO

-- Tipo de disponibilidade do jogo (Venda, Locação, Ambos)
CREATE TABLE JogoVendaLocacao (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Nome NVARCHAR(50) NOT NULL,
    Descricao NVARCHAR(150),
    CONSTRAINT PK_JogoVendaLocacao PRIMARY KEY (Id)
);
GO

-- Jogos 
CREATE TABLE Jogo (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Nome NVARCHAR(150) NOT NULL,
    Desenvolvedora NVARCHAR(100),
    Distribuidora NVARCHAR(100),
    JogoVendaLocacaoId UNIQUEIDENTIFIER NOT NULL,
    Descricao NVARCHAR(MAX),
    Ativo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Jogo PRIMARY KEY (Id),
    CONSTRAINT FK_Jogo_JogoVendaLocacao FOREIGN KEY (JogoVendaLocacaoId) REFERENCES JogoVendaLocacao(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Jogo_JogoVendaLocacaoId ON Jogo(JogoVendaLocacaoId);
GO

-- Tabela de Junção para Jogo e Gênero (Muitos para Muitos)
CREATE TABLE ListaGeneroJogo (
    JogoId UNIQUEIDENTIFIER NOT NULL,
    GeneroId UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_JogoGenero PRIMARY KEY (JogoId, GeneroId),
    CONSTRAINT FK_JogoGenero_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id),
    CONSTRAINT FK_JogoGenero_Genero FOREIGN KEY (GeneroId) REFERENCES GeneroJogo(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_ListaGeneroJogo_JogoId ON ListaGeneroJogo(JogoId);
CREATE NONCLUSTERED INDEX IDX_ListaGeneroJogo_GeneroId ON ListaGeneroJogo(GeneroId);
GO

-- Estoque
CREATE TABLE Estoque (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    JogoId UNIQUEIDENTIFIER NOT NULL,
    Quantidade INT NOT NULL,
    CONSTRAINT PK_Estoque PRIMARY KEY (Id),
    CONSTRAINT FK_Estoque_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id)
);
GO

-- Movimentação de estoque
CREATE TABLE MovimentacaoEstoque (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    JogoId UNIQUEIDENTIFIER NOT NULL,
    TipoMovimentacaoId UNIQUEIDENTIFIER NOT NULL,
    QuantidadeMovimentada INT NOT NULL,
    UsuarioId UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_MovimentacaoEstoque PRIMARY KEY (Id),
    CONSTRAINT FK_MovimentacaoEstoque_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id),
    CONSTRAINT FK_MovimentacaoEstoque_Usuario FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id),
    CONSTRAINT FK_MovimentacaoEstoque_TipoMovimentacao FOREIGN KEY (TipoMovimentacaoId) REFERENCES TipoMovimentacaoEstoque(Id)
);
GO

-- Promoções
CREATE TABLE Promocao (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    JogoId UNIQUEIDENTIFIER NOT NULL,
    PlataformaId UNIQUEIDENTIFIER NOT NULL,
    PrecoPromocional DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Promocao PRIMARY KEY (Id),
    CONSTRAINT FK_Promocao_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id),
    CONSTRAINT FK_Promocao_Plataforma FOREIGN KEY (PlataformaId) REFERENCES Plataforma(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Promocao_Jogo_Plataforma ON Promocao(JogoId, PlataformaId);
GO

-- Tabela de Pagamento 
CREATE TABLE Pagamento (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    Valor DECIMAL(10,2) NOT NULL,
    DataPagamento DATETIME NOT NULL DEFAULT GETDATE(),
    TipoPagamento NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Pagamento PRIMARY KEY (Id)
);
GO

-- Tabela de Pagamento com Cartão de Crédito
CREATE TABLE PagamentoCartaoCredito (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    PagamentoId UNIQUEIDENTIFIER NOT NULL,
    NumeroCartaoFinal NVARCHAR(4) NOT NULL,
    Bandeira NVARCHAR(50),
    TokenTransacao NVARCHAR(255),
    CONSTRAINT PK_PagamentoCartaoCredito PRIMARY KEY (Id),
    CONSTRAINT FK_PagamentoCartaoCredito_Pagamento FOREIGN KEY (PagamentoId) REFERENCES Pagamento(Id)
);
GO

-- Tabela de Pagamento com Pix
CREATE TABLE PagamentoPix (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    PagamentoId UNIQUEIDENTIFIER NOT NULL,
    ChavePix NVARCHAR(255),
    QrCodeBase64 NVARCHAR(MAX),
    DataExpiracao DATETIME,
    CONSTRAINT PK_PagamentoPix PRIMARY KEY (Id),
    CONSTRAINT FK_PagamentoPix_Pagamento FOREIGN KEY (PagamentoId) REFERENCES Pagamento(Id)
);
GO

-- Tabela de Pagamento com Cartão de Débito
CREATE TABLE PagamentoCartaoDebito (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    PagamentoId UNIQUEIDENTIFIER NOT NULL,
    NumeroCartaoFinal NVARCHAR(4) NOT NULL,
    Bandeira NVARCHAR(50),
    TokenTransacao NVARCHAR(255),
    CONSTRAINT PK_PagamentoCartaoDebito PRIMARY KEY (Id),
    CONSTRAINT FK_PagamentoCartaoDebito_Pagamento FOREIGN KEY (PagamentoId) REFERENCES Pagamento(Id)
);
GO

-- Tabela de Transação de Saída (nova tabela para unificar vendas e locações)
CREATE TABLE TransacaoSaida (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    ClienteId UNIQUEIDENTIFIER NOT NULL,
    UsuarioId UNIQUEIDENTIFIER, 
    DataSaida DATETIME NOT NULL DEFAULT GETDATE(),
    TipoSaida NVARCHAR(50) NOT NULL, -- 'Venda' ou 'Locacao'
    ValorTotal DECIMAL(10,2) NOT NULL,
    Desconto DECIMAL(10,2) DEFAULT 0,
    [Status] NVARCHAR(50) NOT NULL,
    PagamentoId UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_TransacaoSaida PRIMARY KEY (Id),
    CONSTRAINT FK_TransacaoSaida_Cliente FOREIGN KEY (ClienteId) REFERENCES Cliente(Id),
    CONSTRAINT FK_TransacaoSaida_Usuario FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id),
    CONSTRAINT FK_TransacaoSaida_Pagamento FOREIGN KEY (PagamentoId) REFERENCES Pagamento(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_TransacaoSaida_ClienteId ON TransacaoSaida(ClienteId);
CREATE NONCLUSTERED INDEX IDX_TransacaoSaida_UsuarioId ON TransacaoSaida(UsuarioId);
CREATE NONCLUSTERED INDEX IDX_TransacaoSaida_PagamentoId ON TransacaoSaida(PagamentoId);
GO

-- Vendas 
CREATE TABLE Venda (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    TransacaoSaidaId UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_Venda PRIMARY KEY (Id),
    CONSTRAINT FK_Venda_TransacaoSaida FOREIGN KEY (TransacaoSaidaId) REFERENCES TransacaoSaida(Id)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX UDX_Venda_TransacaoSaidaId ON Venda(TransacaoSaidaId);
GO

-- Itens da venda
CREATE TABLE VendaItem (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    VendaId UNIQUEIDENTIFIER NOT NULL,
    JogoId UNIQUEIDENTIFIER NOT NULL,
    PrecoVenda DECIMAL(10,2) NOT NULL,
    Quantidade INT NOT NULL,
    CONSTRAINT PK_VendaItem PRIMARY KEY (Id),
    CONSTRAINT FK_VendaItem_Venda FOREIGN KEY (VendaId) REFERENCES Venda(Id),
    CONSTRAINT FK_VendaItem_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id)
);
GO

-- Tabela de Locação
CREATE TABLE Locacao (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    TransacaoSaidaId UNIQUEIDENTIFIER NOT NULL,
    DataLocacao DATETIME NOT NULL DEFAULT GETDATE(),
    DataDevolucaoPrevista DATE NOT NULL,
    DataDevolucaoRealizada DATE,
    ValorDiaria DECIMAL(10,2) NOT NULL,
    StatusLocacao NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Locacao PRIMARY KEY (Id),
    CONSTRAINT FK_Locacao_TransacaoSaida FOREIGN KEY (TransacaoSaidaId) REFERENCES TransacaoSaida(Id)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX UDX_Locacao_TransacaoSaidaId ON Locacao(TransacaoSaidaId);
GO

-- Itens da Locação
CREATE TABLE LocacaoItem (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    LocacaoId UNIQUEIDENTIFIER NOT NULL,
    JogoId UNIQUEIDENTIFIER NOT NULL,
    PrecoLocacao DECIMAL(10,2) NOT NULL,
    Quantidade INT NOT NULL,
    CONSTRAINT PK_LocacaoItem PRIMARY KEY (Id),
    CONSTRAINT FK_LocacaoItem_Locacao FOREIGN KEY (LocacaoId) REFERENCES Locacao(Id),
    CONSTRAINT FK_LocacaoItem_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id)
);
GO

-- Carrinho
CREATE TABLE CarrinhoItem (
    Id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
    ClienteId UNIQUEIDENTIFIER,
    JogoId UNIQUEIDENTIFIER NOT NULL,
    PlataformaId UNIQUEIDENTIFIER NOT NULL,
    Quantidade INT NOT NULL DEFAULT 1,
    PrecoOriginal DECIMAL(10,2) NOT NULL,
    PrecoComDesconto DECIMAL(10,2),
    UsuarioId UNIQUEIDENTIFIER NOT NULL,
    GuidCarrinho UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
    CONSTRAINT PK_CarrinhoItem PRIMARY KEY (Id),
    CONSTRAINT FK_CarrinhoItem_Cliente FOREIGN KEY (ClienteId) REFERENCES Cliente(Id),
    CONSTRAINT FK_CarrinhoItem_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id),
    CONSTRAINT FK_CarrinhoItem_Plataforma FOREIGN KEY (PlataformaId) REFERENCES Plataforma(Id),
    CONSTRAINT FK_CarrinhoItem_Usuario FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id)
);
GO
