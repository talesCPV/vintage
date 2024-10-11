/* POST */

DROP VIEW IF EXISTS vw_post;
CREATE VIEW vw_post AS
	SELECT PST.*, USR.nome, USR.sobrenome,
		SUBSTRING(MONTHNAME(PST.data_hora),1,3) AS mes,
		DAY(PST.data_hora) AS dia,
		YEAR(PST.data_hora) AS ano,
		DATE_FORMAT(PST.data_hora,"%h:%i %p") AS hora,
		(SELECT COUNT(*)FROM tb_post_like WHERE id_post=PST.id) AS likes,
		(SELECT COUNT(*)FROM tb_post_view WHERE id_post=PST.id) AS views,
		(SELECT COUNT(*)FROM tb_post_message WHERE id_post=PST.id) AS messages
		FROM tb_post AS PST
		INNER JOIN tb_usuario AS USR
		ON PST.id_user = USR.id;

