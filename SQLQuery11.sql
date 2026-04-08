 CREATE NONCLUSTERED INDEX IX_vagas_empresa_data 
 ON vagas(empresa_id, data_publicacao DESC) 
 INCLUDE (titulo, modalidade, nivel);

 CREATE INDEX IX_vagas_ativas 
 ON vagas(empresa_id, data_publicacao)
 WHERE ativa = 1;

 CREATE INDEX IX_cand_usuario 
 ON candidaturas(usuario_id, status)
 INCLUDE (vaga_id, data_candidatura);

 SET STATISTICS IO ON;
 SELECT * FROM vagas;

 CREATE NONCLUSTERED INDEX IX_vagas_empresa_data 
 ON vagas(empresa_id, data_publicacao DESC) 
 INCLUDE (titulo, modalidade, nivel);

 SELECT * FROM vagas;

  
