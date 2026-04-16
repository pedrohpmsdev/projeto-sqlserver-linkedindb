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

--13.4

CREATE OR ALTER FUNCTION fn_score_perfil
(@usuario_id INT)
RETURNS INT
AS
BEGIN
DECLARE @resultado1 INT 
SET @resultado1 = (SELECT COUNT(*) FROM usuario_habilidades WHERE usuario_id = @usuario_id)*10;

DECLARE @resultado2 INT 
SET @resultado2 = (SELECT COUNT(*) FROM experiencias WHERE usuario_id = @usuario_id)*15;

DECLARE @resultado3 INT 
SET @resultado3 = (SELECT COUNT(*) FROM conexoes WHERE (usuario_origem = @usuario_id OR usuario_destino = @usuario_id) AND status = 'aceita')*5;

DECLARE @resultado4 INT 
SET @resultado4 = (SELECT COUNT(*) FROM usuarios WHERE usuario_id = @usuario_id AND premium = 1)*20;

DECLARE @resultadoFinal INT 
SET @resultadoFinal = @resultado1 + @resultado2 + @resultado3 + @resultado4
RETURN @resultadoFinal
END

SELECT TOP(10) dbo.fn_score_perfil(usuario_id) AS pts, usuario_id, nome
FROM usuarios
ORDER BY pts DESC

SELECT * from usuarios where usuario_id = 14
SELECT * FROM usuario_habilidades where usuario_id = 14
SELECT * FROM conexoes where (usuario_destino = 14 OR usuario_origem = 14) AND status = 'aceita'

--14.1
SELECT 
e.empresa_id,
v.modalidade,
COUNT(vaga_id) AS totalVagas
FROM empresas AS e
INNER JOIN vagas AS v ON v.empresa_id = e.empresa_id
GROUP BY e.empresa_id, v.modalidade
ORDER BY empresa_id ASC

--14.2 --- CORRIGIR
SELECT
fk_setor_id,
(
(CAST((SELECT COUNT(*) FROM candidaturas WHERE status = 'aceita')
/
(SELECT COUNT(*) FROM candidaturas) AS DECIMAL))
- 
(CAST((SELECT COUNT(*) FROM candidaturas WHERE status = 'reprovada')
/
(SELECT COUNT(*) FROM candidaturas) AS DECIMAL))
) AS NPS
FROM vagas AS v
INNER JOIN empresas AS e ON v.empresa_id = e.empresa_id
INNER JOIN setores AS s ON e.fk_setor_id = s.setor_id
GROUP BY e.fk_setor_id
ORDER BY e.fk_setor_id;


 
