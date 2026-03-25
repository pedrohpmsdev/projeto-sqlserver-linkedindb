use linkedin_db;

UPDATE curtidas SET data_curtida = '2026-03-24 13:09:55.4900000';

SELECT p.post_id, p.usuario_id, p.data_publicacao FROM posts AS p
INNER JOIN usuarios AS u ON u.usuario_id = p.usuario_id
INNER JOIN curtidas AS c ON c.usuario_id = u.usuario_id
WHERE p.post_id IN 
(SELECT p.post_id FROM curtidas AS c
INNER JOIN posts AS p ON p.post_id = c.post_id
GROUP BY p.post_id, c.data_curtida
HAVING COUNT(c.usuario_id) >= 3 AND DATEDIFF(day, c.data_curtida, GETDATE()) <= 7 
)
GROUP BY p.post_id, p.usuario_id, p.data_publicacao
ORDER BY p.post_id;

SELECT * FROM curtidas
INSERT INTO curtidas (post_id, usuario_id)
VALUES
(14, 9)
UPDATE curtidas SET data_curtida = '2026-02-24 13:09:55.4900000' WHERE post_id = 13;

SELECT COUNT(*) AS qtdVagas, e.nome FROM vagas AS v
INNER JOIN empresas AS e ON v.empresa_id = e.empresa_id
WHERE v.ativa = 1
GROUP BY e.empresa_id, e.nome, v.titulo
ORDER BY qtdVagas DESC 
-- FALTA SO A LOGICA DE SER MAIOR QUE A MEDIA 

SELECT  
TOP (5) COUNT(*) AS qtdAssociacoes, 
habilidade_id, 
CAST(COUNT(*)*100/(SELECT COUNT(*) FROM usuario_habilidades) AS FLOAT) AS percentual FROM usuario_habilidades 
GROUP BY habilidade_id
ORDER BY qtdAssociacoes DESC

SELECT 
COUNT(*) AS qtdCandidaturas, 
CAST(COUNT(*)*100/(SELECT COUNT(*) FROM candidaturas) AS FLOAT) AS percentual FROM candidaturas 
GROUP BY status
ORDER BY qtdCandidaturas DESC

SELECT * FROM usuarios 
WHERE titulo_perfil LIKE 'Engenheiro' 
OR titulo_perfil LIKE 'Analista' 
OR titulo_perfil LIKE 'Desenvolvedor';

