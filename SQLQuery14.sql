 
---------- tarefa 13
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

CREATE OR ALTER FUNCTION fn_conexoes_usuario
(@usuario_id INT)
RETURNS TABLE
AS  
RETURN (SELECT * FROM conexoes WHERE status = 'aceita');

---------- tarefa 12 

CREATE OR ALTER PROCEDURE sp_registrar_candidatura
(
    @usuario_id INT, 
    @vaga_id INT,
    @carta_apresentacao NVARCHAR(300)
)
AS
BEGIN
IF EXISTS (
    SELECT 1 FROM usuarios 
    WHERE usuario_id = @usuario_id AND ativo = 1
)
AND EXISTS (
    SELECT 1 FROM vagas 
    WHERE vaga_id = @vaga_id AND ativa = 1 AND DATEDIFF(DAY, GETDATE(), data_expiracao) >= 0

)
AND NOT EXISTS (
    SELECT 1 FROM candidaturas 
    WHERE usuario_id = @usuario_id AND vaga_id = @vaga_id
)

BEGIN
    INSERT INTO candidaturas (usuario_id, vaga_id, carta_apresentacao)
    VALUES (@usuario_id, @vaga_id, @carta_apresentacao)

    SELECT * 
    FROM candidaturas AS c
    INNER JOIN usuarios AS u ON c.usuario_id = u.usuario_id
    INNER JOIN vagas AS v ON c.vaga_id = v.vaga_id
    WHERE c.usuario_id = @usuario_id AND c.vaga_id = @vaga_id
END
ELSE
BEGIN
    PRINT 'Condições não atendidas';
END
END

EXEC sp_registrar_candidatura @usuario_id = 7, @vaga_id = 8, @carta_apresentacao = 'e'

