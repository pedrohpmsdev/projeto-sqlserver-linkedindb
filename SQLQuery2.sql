CREATE DATABASE linkedin_db
COLLATE Latin1_General_CI_AI;
USE linkedin_db;
SELECT name, create_date, collation_name, compatibility_level
FROM sys.databases
ORDER BY create_date DESC;
SELECT @@VERSION;
SELECT name, value_in_use
FROM sys.configurations
WHERE name IN ('max degree of parallelism',
'cost threshold for parallelism',
'max server memory (MB)');

CREATE TABLE setores (
setor_id INT IDENTITY(1,1) PRIMARY KEY,
nome NVARCHAR(100) NOT NULL
);

CREATE TABLE habilidades (
habilidade_id INT IDENTITY(1,1) PRIMARY KEY,
nome NVARCHAR(100) NOT NULL,
categoria VARCHAR(20) NOT NULL
);

CREATE TABLE empresas (
empresa_id INT IDENTITY(1,1) PRIMARY KEY,
nome NVARCHAR(200) NOT NULL,
tamanho VARCHAR(20) NOT NULL,
cidade NVARCHAR(100) NOT NULL,
pais CHAR(3) DEFAULT 'BRA',
fundada_em SMALLINT NULL,
site VARCHAR(200) NULL,
ativa BIT DEFAULT 1,
fk_setor_id INT NOT NULL FOREIGN KEY REFERENCES setores(setor_id)
);

CREATE TABLE usuarios (
usuario_id INT IDENTITY(1,1) PRIMARY KEY,
nome NVARCHAR(120) NOT NULL,
email VARCHAR(180) NOT NULL,
titulo_perfil NVARCHAR(220) NULL,
cidade NVARCHAR(100) NULL,
pais CHAR(3) DEFAULT 'BRA',
data_cadastro DATETIME2 DEFAULT GETDATE(),
premium BIT DEFAULT 0,
ativo BIT DEFAULT 1
);

CREATE TABLE usuario_habilidades (
usuario_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
habilidade_id INT NOT NULL FOREIGN KEY REFERENCES habilidades(habilidade_id),
nivel VARCHAR(20) NOT NULL
);

CREATE TABLE experiencias (
exp_id INT IDENTITY(1,1) PRIMARY KEY,
usuario_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
empresa_id INT NOT NULL FOREIGN KEY REFERENCES empresas(empresa_id),
cargo NVARCHAR(150) NOT NULL,
data_inicio DATE NOT NULL,
data_fim DATE NULL,
descricao NVARCHAR(1000) NULL
);

CREATE TABLE conexoes (
conexao_id INT IDENTITY(1,1) PRIMARY KEY,
usuario_origem INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
usuario_destino INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
status VARCHAR(15) NOT NULL,
data_solicitacao DATETIME2 DEFAULT GETDATE(),
data_resposta DATETIME2 NULL
);

CREATE TABLE vagas (
vaga_id INT IDENTITY(1,1) PRIMARY KEY,
empresa_id INT NOT NULL FOREIGN KEY REFERENCES empresas(empresa_id),
titulo NVARCHAR(200) NOT NULL,
descricao NVARCHAR(MAX) NULL,
cidade NVARCHAR(100) NOT NULL,
modalidade VARCHAR(20) NOT NULL,
nivel VARCHAR(20) NOT NULL,
salario_min DECIMAL(10,2) NULL,
salario_max DECIMAL(10,2) NULL,
data_publicacao DATETIME2 DEFAULT GETDATE(),
data_expiracao DATE NULL,
ativa BIT DEFAULT 1
);

CREATE TABLE candidaturas (
candidatura_id INT IDENTITY(1,1) PRIMARY KEY,
usuario_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
vaga_id INT NOT NULL FOREIGN KEY REFERENCES vagas(vaga_id),
status VARCHAR(25) DEFAULT 'enviada',
data_candidatura DATETIME2 DEFAULT GETDATE(),
data_atualizacao DATETIME2 NULL,
carta_apresentacao NVARCHAR(2000) NULL
);

CREATE TABLE posts (
post_id INT IDENTITY(1,1) PRIMARY KEY,
usuario_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
conteudo NVARCHAR(3000) NOT NULL,
tipo VARCHAR(20) DEFAULT 'texto',
data_publicacao DATETIME2 DEFAULT GETDATE(),
visualizacoes INT DEFAULT 0,
ativo BIT DEFAULT 1
);

CREATE TABLE curtidas (
curtida_id INT IDENTITY(1,1) PRIMARY KEY,
usuario_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
post_id INT NOT NULL FOREIGN KEY REFERENCES posts(post_id),
reacao VARCHAR(15) DEFAULT 'curtir',
data_curtida DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE comentarios (
comentario_id INT IDENTITY(1,1) PRIMARY KEY,
usuario_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
post_id INT NOT NULL FOREIGN KEY REFERENCES posts(post_id),
conteudo NVARCHAR(1000) NOT NULL,
data_comentario DATETIME2 DEFAULT GETDATE()
);

ALTER TABLE usuarios ADD linkedin_url VARCHAR(200) UNIQUE;

CREATE TABLE mensagens (
mensagem_id INT IDENTITY(1,1) PRIMARY KEY,
rementente_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
destinatario_id INT NOT NULL FOREIGN KEY REFERENCES usuarios(usuario_id),
conteudo NVARCHAR(1000) NOT NULL,
data_envio DATETIME2 DEFAULT GETDATE(),
lida BIT DEFAULT 0
);

SELECT * FROM INFORMATION_SCHEMA.TABLES;
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

INSERT INTO setores (nome)
VALUES 
('Tecnologia'),
('Financas'),
('Saude'),
('Educacao'),
('Varejo'),
('Logistica'),
('Marketing'),
('Consultoria');