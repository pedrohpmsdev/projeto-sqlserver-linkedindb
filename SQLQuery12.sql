
 CREATE NONCLUSTERED INDEX IX_vagas_empresa_data 
 ON vagas(empresa_id, data_publicacao DESC) 
 INCLUDE (titulo, modalidade, nivel);

 CREATE INDEX IX_vagas_ativas 
 ON vagas(empresa_id, data_publicacao)
 WHERE ativa = 1;

 CREATE INDEX IX_cand_usuario 
 ON candidaturas(usuario_id, status)
 INCLUDE (vaga_id, data_candidatura);

 DROP INDEX IX_vagas_empresa_data ON vagas;
 DROP INDEX IX_vagas_ativas ON vagas;

 SET STATISTICS IO ON;
 SELECT *
 FROM vagas WITH (INDEX(IX_vagas_empresa_data))
 WHERE empresa_id = 2
 OPTION (RECOMPILE)
 SELECT vaga_id, empresa_id, data_expiracao, titulo, modalidade, nivel FROM vagas WHERE empresa_id = 2;
 SELECT * FROM vagas WHERE ativa = 1;

 SELECT * FROM empresas;

 CREATE NONCLUSTERED INDEX IX_vagas_empresa_data 
 ON vagas(empresa_id, data_publicacao DESC) 
 INCLUDE (titulo, modalidade, nivel);

 SELECT * FROM vagas;

  
