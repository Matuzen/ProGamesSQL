CREATE DATABASE ProGames;
GO

USE ProGames;
GO


-- Tipo de movimenta��o de estoque
CREATE TABLE TipoMovimentacaoEstoque (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_TipoMovimentacaoEstoque PRIMARY KEY (Id)
);
GO

-- Tabela de Usu�rios
CREATE TABLE Usuario (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    SenhaHash NVARCHAR(255) NOT NULL,
    Ativo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Usuario PRIMARY KEY (Id)
);
GO

-- Tabela de Formas de Pagamento
CREATE TABLE FormaPagamento (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(50) NOT NULL,
    Descricao NVARCHAR(150),
    CONSTRAINT PK_FormaPagamento PRIMARY KEY (Id)
);
GO

-- Tabela de Status de Venda
CREATE TABLE StatusVenda (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(50) NOT NULL,
    Descricao NVARCHAR(150),
    CONSTRAINT PK_StatusVenda PRIMARY KEY (Id)
);
GO

-- Tabela de Tipo de Venda
CREATE TABLE TipoVenda (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_TipoVenda PRIMARY KEY (Id)
);
GO

-- Fabricantes de plataformas
CREATE TABLE FabricantePlataforma (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_FabricantePlataforma PRIMARY KEY (Id)
);
GO

-- G�neros de jogos
CREATE TABLE GeneroJogo (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(50) NOT NULL,
    Descricao NVARCHAR(150),
    CONSTRAINT PK_GeneroJogo PRIMARY KEY (Id)
);
GO

-- Clientes
CREATE TABLE Cliente (
    Id INT IDENTITY(1,1),
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
    Id INT IDENTITY(1,1),
    ClienteId INT NOT NULL,
    Telefone NVARCHAR(20),
    Email NVARCHAR(100),
    CONSTRAINT PK_Contato PRIMARY KEY (Id),
    CONSTRAINT FK_Contato_Cliente FOREIGN KEY (ClienteId) REFERENCES Cliente(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Contato_ClienteId ON Contato(ClienteId);
CREATE NONCLUSTERED INDEX IDX_Contato_Email ON Contato(Email);
GO

-- Endere�o dos clientes
CREATE TABLE EnderecoCliente (
    Id INT IDENTITY(1,1),
    ClienteId INT NOT NULL,
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
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL,
    FabricanteId INT NOT NULL,
    CONSTRAINT PK_Plataforma PRIMARY KEY (Id),
    CONSTRAINT FK_Plataforma_Fabricante FOREIGN KEY (FabricanteId) REFERENCES FabricantePlataforma(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Plataforma_FabricanteId ON Plataforma(FabricanteId);
GO

-- Jogos
CREATE TABLE Jogo (
    Id INT IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Desenvolvedora NVARCHAR(100),
    Distribuidora NVARCHAR(100),
    GeneroId INT,
    Descricao NVARCHAR(MAX),
    Ativo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Jogo PRIMARY KEY (Id),
    CONSTRAINT FK_Jogo_Genero FOREIGN KEY (GeneroId) REFERENCES GeneroJogo(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Jogo_GeneroId ON Jogo(GeneroId);
GO

-- Estoque
CREATE TABLE Estoque (
    Id INT IDENTITY(1,1),
    JogoId INT NOT NULL,
    Quantidade INT NOT NULL,
    CONSTRAINT PK_Estoque PRIMARY KEY (Id),
    CONSTRAINT FK_Estoque_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id)
);
GO

-- Movimenta��o de estoque
CREATE TABLE MovimentacaoEstoque (
    Id INT IDENTITY(1,1),
    JogoId INT NOT NULL,
    TipoMovimentacaoId INT NOT NULL,
    QuantidadeMovimentada INT NOT NULL,
    UsuarioId INT NOT NULL,
    CONSTRAINT PK_MovimentacaoEstoque PRIMARY KEY (Id),
    CONSTRAINT FK_MovimentacaoEstoque_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id),
    CONSTRAINT FK_MovimentacaoEstoque_Usuario FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id),
    CONSTRAINT FK_MovimentacaoEstoque_TipoMovimentacao FOREIGN KEY (TipoMovimentacaoId) REFERENCES TipoMovimentacaoEstoque(Id)
);
GO

-- Promo��es
CREATE TABLE Promocao (
    Id INT IDENTITY(1,1),
    JogoId INT NOT NULL,
    PlataformaId INT NOT NULL,
    PrecoPromocional DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Promocao PRIMARY KEY (Id),
    CONSTRAINT FK_Promocao_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id),
    CONSTRAINT FK_Promocao_Plataforma FOREIGN KEY (PlataformaId) REFERENCES Plataforma(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Promocao_Jogo_Plataforma ON Promocao(JogoId, PlataformaId);
GO

-- Vendas
CREATE TABLE Venda (
    Id INT IDENTITY(1,1),
    ClienteId INT NOT NULL,
    TipoVendaId INT NOT NULL,
    ValorTotal DECIMAL(10,2),
    Desconto DECIMAL(10,2),
    FormaPagamentoId INT NOT NULL,
    StatusVendaId INT NOT NULL,
    UsuarioId INT NOT NULL,
    CONSTRAINT PK_Venda PRIMARY KEY (Id),
    CONSTRAINT FK_Venda_Cliente FOREIGN KEY (ClienteId) REFERENCES Cliente(Id),
    CONSTRAINT FK_Venda_FormaPagamento FOREIGN KEY (FormaPagamentoId) REFERENCES FormaPagamento(Id),
    CONSTRAINT FK_Venda_StatusVenda FOREIGN KEY (StatusVendaId) REFERENCES StatusVenda(Id),
    CONSTRAINT FK_Venda_TipoVenda FOREIGN KEY (TipoVendaId) REFERENCES TipoVenda(Id),
    CONSTRAINT FK_Venda_Usuario FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id)
);
GO

CREATE NONCLUSTERED INDEX IDX_Venda_ClienteId ON Venda(ClienteId);
GO

-- Itens da venda
CREATE TABLE VendaItem (
    Id INT IDENTITY(1,1),
    VendaId INT NOT NULL,
    JogoId INT NOT NULL,
    PrecoVenda DECIMAL(10,2) NOT NULL,
    Quantidade INT NOT NULL,
    CONSTRAINT PK_VendaItem PRIMARY KEY (Id),
    CONSTRAINT FK_VendaItem_Venda FOREIGN KEY (VendaId) REFERENCES Venda(Id),
    CONSTRAINT FK_VendaItem_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id)
);
GO

-- Carrinho (pr�-venda)
CREATE TABLE CarrinhoItem (
    Id INT IDENTITY(1,1),
    ClienteId INT,
    JogoId INT NOT NULL,
    PlataformaId INT NOT NULL,
    Quantidade INT NOT NULL DEFAULT 1,
    PrecoOriginal DECIMAL(10,2) NOT NULL,
    PrecoComDesconto DECIMAL(10,2),
    UsuarioId INT NOT NULL,
    GuidCarrinho UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    CONSTRAINT PK_CarrinhoItem PRIMARY KEY (Id),
    CONSTRAINT FK_CarrinhoItem_Cliente FOREIGN KEY (ClienteId) REFERENCES Cliente(Id),
    CONSTRAINT FK_CarrinhoItem_Jogo FOREIGN KEY (JogoId) REFERENCES Jogo(Id),
    CONSTRAINT FK_CarrinhoItem_Plataforma FOREIGN KEY (PlataformaId) REFERENCES Plataforma(Id),
    CONSTRAINT FK_CarrinhoItem_Usuario FOREIGN KEY (UsuarioId) REFERENCES Usuario(Id)
);
GO
