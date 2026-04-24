-- 18.1

-- 18.2
WITH cte_conexoes_diretas AS (
SELECT COUNT(*) AS total1Grau, usuario_origem AS usuario_origemC1 FROM conexoes
GROUP BY usuario_origem
),
cte_conexoes_2grau AS (
SELECT 
DISTINCT COUNT(c2.conexao_id) AS total2Grau
FROM conexoes AS c1
JOIN conexoes AS c2 ON c1.usuario_destino = c2.usuario_origem
GROUP BY c1.usuario_origem
),
cte_premium AS (
	SELECT COUNT(usuario_id) AS quantidade FROM usuarios AS u
	JOIN conexoes AS c ON c.usuario_origem = u.usuario_id
	WHERE u.premium = 1
)
SELECT 
usuario_origemC1,
total1Grau,
total2Grau,
quantidade
FROM cte_conexoes_diretas, cte_conexoes_2grau, cte_premium
GROUP BY total1Grau,
usuario_origemC1,
total2Grau,
quantidade

SELECT * FROM conexoes

-- 18.3 ver pq ta dando valores grandes, isoladamente ta certo
SELECT
TOP(5)
u.usuario_id,
(COUNT(c.conexao_id)*2 
+ COUNT(p.post_id)*3 
+ COUNT(ct.curtida_id)) AS pontos
FROM usuarios AS u
JOIN conexoes AS c ON c.usuario_origem = u.usuario_id
JOIN posts AS p ON p.usuario_id = u.usuario_id
JOIN curtidas AS ct ON ct.post_id = p.post_id
WHERE c.status = 'aceita'
GROUP BY u.usuario_id
ORDER BY pontos DESC

/*SELECT * FROM conexoes
WHERE status = 'aceita'

SELECT u.usuario_id, COUNT(*) FROM curtidas ct
   JOIN posts AS p ON ct.post_id = p.post_id
   JOIN usuarios AS u ON u.usuario_id = p.usuario_id
   GROUP BY u.usuario_id
   

select * from conexoes
select * from posts
select * from curtidas*/ 

-- 19.1 erro no fn e no string agg
CREATE OR ALTER VIEW vw_perfil_completo AS
SELECT 
nome,
email,
titulo_perfil,
cidade,
COUNT(c.conexao_id) AS conexoes_aceitas,
COUNT(p.post_id) AS qtd_posts,
COUNT(ct.curtida_id) AS curtidas_recebidas,
STRING_AGG(CONVERT (NVARCHAR (MAX), habilidade_id), ';')
FROM usuarios AS u
JOIN usuario_habilidades AS uh ON uh.usuario_id = u.usuario_id
JOIN conexoes AS c ON c.usuario_origem = u.usuario_id
JOIN posts AS p ON p.usuario_id = u.usuario_id
JOIN curtidas AS ct ON ct.post_id = p.post_id
WHERE c.status = 'aceita'
GROUP BY u.nome, u.email, u.titulo_perfil, u.cidade

exec fn_score_perfil @usuario_id = usuario_id 
 

-- 19.2 ver pq count 0 n aparece a linha
CREATE OR ALTER vw_vagas_completas AS
SELECT 
v.vaga_id,
titulo,
e.empresa_id,
s.setor_id,
v.cidade,
v.modalidade,
v.nivel,
CONCAT('R$ ', salario_min, ' - R$ ', salario_max) AS faixa_salarial,
DATEDIFF(day, MAX(v.data_publicacao), GETDATE()) AS dias_desde_ultima_publi,
COUNT(candidatura_id) AS total_candidaturas
FROM vagas AS v
JOIN empresas AS e ON e.empresa_id = v.empresa_id
JOIN setores AS s ON s.setor_id = e.empresa_id
JOIN candidaturas AS c ON v.vaga_id = c.vaga_id
GROUP BY v.vaga_id, v.titulo, e.empresa_id, s.setor_id, v.cidade, v.modalidade, v.nivel, v.salario_min, v.salario_max

select * from vagas
select * from candidaturas

-- 19.3 como avaliar média de dias para preenchimento? taxa bugada
CREATE OR ALTER vw_empresa_dashboard AS
SELECT 
e.nome,
e.empresa_id,
s.nome, 
e.tamanho,
(SELECT STRING_AGG(CONVERT (NVARCHAR (MAX), v.vaga_id), ';')
 FROM empresas AS e2
 JOIN vagas AS v ON v.empresa_id = e2.empresa_id 
 WHERE v.ativa = 1 AND e.empresa_id = e2.empresa_id) AS vagas_ativas,
COUNT (candidatura_id) AS total_candidaturas,
CAST((CAST((SELECT COUNT(*) FROM candidaturas
 WHERE status = 'aceita') AS DECIMAL)/NULLIF((SELECT COUNT(*) FROM candidaturas), 0)) AS DECIMAL (10,2)) AS taxa_aprovacao
FROM empresas AS e
JOIN setores AS s ON s.setor_id = e.fk_setor_id
JOIN vagas AS v ON v.empresa_id = e.empresa_id
JOIN candidaturas c ON c.vaga_id = v.vaga_id
GROUP BY e.nome, e.empresa_id, s.nome, e.tamanho

select * from vagas
join empresas on empresas.empresa_id = vagas.empresa_id
