--Tarefa 12, exercícios 3 e 4

--SEM TRY/CATCH
CREATE OR ALTER PROCEDURE sp_registrar_candidatura
(
    @usuario_id INT, 
    @vaga_id INT,
    @carta_apresentacao NVARCHAR(300)
)
AS
BEGIN
BEGIN TRANSACTION
IF NOT EXISTS (
    SELECT 1 FROM usuarios 
    WHERE usuario_id = @usuario_id AND ativo = 1
)
THROW 50010, 'Usuário não existe ou não está ativo', 1;

IF NOT EXISTS (
    SELECT 1 FROM vagas 
    WHERE vaga_id = @vaga_id AND ativa = 1 AND DATEDIFF(DAY, GETDATE(), data_expiracao) >= 0
)
THROW 50011, 'Vaga não existe ou não está ativa ou está expirada', 1;

    
IF EXISTS (
    SELECT 1 FROM candidaturas 
    WHERE usuario_id = @usuario_id AND vaga_id = @vaga_id
)
THROW 50012, 'Candidatura já existe', 1;

INSERT INTO candidaturas (usuario_id, vaga_id, carta_apresentacao)
VALUES (@usuario_id, @vaga_id, @carta_apresentacao)

SELECT * 
FROM candidaturas AS c
INNER JOIN usuarios AS u ON c.usuario_id = u.usuario_id
INNER JOIN vagas AS v ON c.vaga_id = v.vaga_id
WHERE c.usuario_id = @usuario_id AND c.vaga_id = @vaga_id
COMMIT TRANSACTION;
END;

EXEC sp_registrar_candidatura @usuario_id = 7, @vaga_id = 8, @carta_apresentacao = 'e'

-- COM TRY/CATCH
CREATE OR ALTER PROCEDURE sp_registrar_candidatura
(
    @usuario_id INT, 
    @vaga_id INT,
    @carta_apresentacao NVARCHAR(300)
)
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
BEGIN TRANSACTION
IF NOT EXISTS (
    SELECT 1 FROM usuarios 
    WHERE usuario_id = @usuario_id AND ativo = 1
)
THROW 50010, 'Usuário não existe ou não está ativo', 1;

IF NOT EXISTS (
    SELECT 1 FROM vagas 
    WHERE vaga_id = @vaga_id AND ativa = 1 AND DATEDIFF(DAY, GETDATE(), data_expiracao) >= 0
)
THROW 50011, 'Vaga não existe ou não está ativa ou está expirada', 1;

    
IF EXISTS (
    SELECT 1 FROM candidaturas 
    WHERE usuario_id = @usuario_id AND vaga_id = @vaga_id
)
THROW 50012, 'Candidatura já existe', 1;

INSERT INTO candidaturas (usuario_id, vaga_id, carta_apresentacao)
VALUES (@usuario_id, @vaga_id, @carta_apresentacao)
SELECT * 
FROM candidaturas AS c
INNER JOIN usuarios AS u ON c.usuario_id = u.usuario_id
INNER JOIN vagas AS v ON c.vaga_id = v.vaga_id
WHERE c.usuario_id = @usuario_id AND c.vaga_id = @vaga_id
COMMIT TRANSACTION;
END TRY 
BEGIN CATCH
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
THROW 50013, 'credenciais inválidas', 1;
END CATCH 
END;

EXEC sp_registrar_candidatura @usuario_id = 7, @vaga_id = 8, @carta_apresentacao = 'e';
 
SELECT * FROM candidaturas
SELECT * FROM usuarios
SELECT * FROM vagas


--Tarefa 13, exercícios 3 e 4

CREATE TABLE vaga_habilidades (
vaga_id INT NOT NULL FOREIGN KEY REFERENCES vagas(vaga_id),
habilidade_id INT NOT NULL FOREIGN KEY REFERENCES habilidades(habilidade_id),
)

INSERT INTO vaga_habilidades (vaga_id, habilidade_id)
VALUES
(8, 1),
(8, 2),
(8, 3),
(9, 4), 
(9, 5),
(9, 6),
(10, 7), 
(10, 8),
(10, 9)
 
CREATE OR ALTER FUNCTION fn_vagas_recomendadas
(@usuario_id INT)
RETURNS TABLE
AS
  
RETURN(
SELECT * FROM vagas AS v
INNER JOIN vaga_habilidades AS vh ON vh.vaga_id = v.vaga_id
WHERE (SELECT COUNT(*) FROM vaga_habilidades WHERE vh.vaga_id = v.vaga_id) >= 4

--CORRIGIR
);

CREATE OR ALTER FUNCTION fn_score_perfil
(@usuario_id INT)
RETURNS INT
AS
BEGIN
DECLARE @resultado INT 
SET @resultado = (SELECT COUNT(*) FROM usuario_habilidades WHERE usuario_id = @usuario_id)*10;
SET @resultado = (SELECT COUNT(*) FROM experiencias WHERE usuario_id = @usuario_id)*15;
SET @resultado = (SELECT COUNT(*) FROM conexoes WHERE (usuario_origem = @usuario_id OR usuario_destino = @usuario_id) AND status = 'aceita')*5;SET @resultado = (SELECT COUNT(*) FROM conexoes WHERE (usuario_origem = @usuario_id OR usuario_destino = @usuario_id) AND status = 'aceita')*5;
SET @resultado = (SELECT COUNT(*) FROM usuarios WHERE usuario_id = @usuario_id AND premium = 1)*20;

RETURN @resultado
END

SELECT TOP(10) dbo.fn_score_perfil(usuario_id) AS pts, usuario_id, nome
FROM usuarios
ORDER BY pts DESC

SELECT * FROM usuario_habilidades
