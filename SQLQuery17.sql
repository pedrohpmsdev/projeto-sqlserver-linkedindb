--14.2
SELECT s.setor_id, (
(CAST((SELECT COUNT(*) FROM candidaturas AS c
		JOIN vagas AS v ON c.vaga_id = v.vaga_id
		JOIN empresas AS e ON e.empresa_id = v.empresa_id
		JOIN setores AS s ON e.fk_setor_id = s.setor_id
		WHERE status = 'aceita' AND e2.fk_setor_id = s.setor_id) AS DECIMAL(10,1)))
/
(SELECT COUNT(*) FROM candidaturas AS c
		JOIN vagas AS v ON c.vaga_id = v.vaga_id
		JOIN empresas AS e ON e.empresa_id = v.empresa_id
		JOIN setores AS s ON e.fk_setor_id = s.setor_id
		WHERE e2.fk_setor_id = s.setor_id)
- 
(CAST((SELECT COUNT(*) FROM candidaturas AS c
		JOIN vagas AS v ON c.vaga_id = v.vaga_id
		JOIN empresas AS e ON e.empresa_id = v.empresa_id
		JOIN setores AS s ON e.fk_setor_id = s.setor_id
		WHERE status = 'reprovada' AND e2.fk_setor_id = s.setor_id) AS DECIMAL(10,1)))
/
(SELECT COUNT(*) FROM candidaturas AS c
		JOIN vagas AS v ON c.vaga_id = v.vaga_id
		JOIN empresas AS e ON e.empresa_id = v.empresa_id
		JOIN setores AS s ON e.fk_setor_id = s.setor_id
		WHERE e2.fk_setor_id = s.setor_id)
) AS NPS
FROM vagas AS v
JOIN empresas AS e2 ON v.empresa_id = e2.empresa_id
JOIN setores AS s ON e2.fk_setor_id = s.setor_id
GROUP BY s.setor_id, e2.fk_setor_id
ORDER BY s.setor_id;

--14.3
SELECT TOP(1) DATEPART(hour, data_publicacao) AS goldenHour,
COUNT(*) AS totalVendas
FROM posts
GROUP BY data_publicacao
ORDER BY data_publicacao DESC

--14.4
SELECT COUNT(candidatura_id) AS total, v.empresa_id FROM candidaturas AS c
INNER JOIN vagas AS v ON v.vaga_id = c.vaga_id
INNER JOIN empresas AS e ON e.empresa_id = v.empresa_id
GROUP BY v.empresa_id WITH ROLLUP;


