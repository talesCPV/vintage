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
        
/* ACERVO */ 
DROP VIEW IF EXISTS vw_acervo;
	CREATE VIEW vw_acervo AS
        SELECT ACV.*, OWN.nome AS owner_name, OWN.sobrenome AS owner_surname, OWN.email
        FROM tb_acervo AS ACV
        INNER JOIN tb_usuario AS OWN
        ON ACV.id_owner = OWN.id;
        
/* VCL DESEMPENHO */
 DROP VIEW IF EXISTS vw_vcl_desempenho;
 	CREATE VIEW vw_vcl_desempenho AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_desempenho AS CHD
		ON CHD.id_vcl = VCL.id;

SELECT * FROM vw_vcl_desempenho;

/* VCL MOTOR */
 DROP VIEW IF EXISTS vw_vcl_motor;
 	CREATE VIEW vw_vcl_motor AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_motor AS CHD
		ON CHD.id_vcl = VCL.id;
        
SELECT * FROM vw_vcl_motor;        
        
/* VCL TRANSMISSÂO */
 DROP VIEW IF EXISTS vw_vcl_transmissao;
 	CREATE VIEW vw_vcl_transmissao AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_transmissao AS CHD
		ON CHD.id_vcl = VCL.id;
        
SELECT * FROM vw_vcl_transmissao;        
        
/* VCL DIMENSÂO */
 DROP VIEW IF EXISTS vw_vcl_dimensao;
 	CREATE VIEW vw_vcl_dimensao AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_dimensao AS CHD
		ON CHD.id_vcl = VCL.id;
        
SELECT * FROM vw_vcl_dimensao;
        
/* VCL PNEUS */
 DROP VIEW IF EXISTS vw_vcl_pneus;
 	CREATE VIEW vw_vcl_pneus AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_pneus AS CHD
		ON CHD.id_vcl = VCL.id;

SELECT * FROM vw_vcl_pneus;

/* VCL AERODINAMICA */
 DROP VIEW IF EXISTS vw_vcl_aerodinamica;
 	CREATE VIEW vw_vcl_aerodinamica AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_aerodinamica AS CHD
		ON CHD.id_vcl = VCL.id;    
        
SELECT * FROM vw_vcl_aerodinamica;
        
/* VCL DIREÇÃO */
 DROP VIEW IF EXISTS vw_vcl_direcao;
 	CREATE VIEW vw_vcl_direcao AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_direcao AS CHD
		ON CHD.id_vcl = VCL.id;   
        
SELECT * FROM vw_vcl_direcao;
        
/* VCL SUSPENSÃO */
 DROP VIEW IF EXISTS vw_vcl_suspensao;
 	CREATE VIEW vw_vcl_suspensao AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_suspensao AS CHD
		ON CHD.id_vcl = VCL.id; 
        
SELECT * FROM vw_vcl_suspensao;
        
/* VCL FREIOS */
 DROP VIEW IF EXISTS vw_vcl_freios;
 	CREATE VIEW vw_vcl_freios AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_freios AS CHD
		ON CHD.id_vcl = VCL.id;
        
SELECT * FROM vw_vcl_freios;
        
/* VCL CONSUMO */
 DROP VIEW IF EXISTS vw_vcl_consumo;
 	CREATE VIEW vw_vcl_consumo AS
		SELECT VCL.id, CHD.*
		FROM tb_veiculo AS VCL
		LEFT JOIN tb_vcl_consumo AS CHD
		ON CHD.id_vcl = VCL.id;
        
SELECT * FROM vw_vcl_consumo;
        
/* VCL FREIOS */
 DROP VIEW IF EXISTS vw_veiculos;
 	CREATE VIEW vw_veiculos AS
		SELECT VCL.*,
        DES.ace_0_100, DES.vel_max,
        MOT.aci_comando,MOT.alimentacao,MOT.aspiracao,MOT.cilindrada,MOT.cilindros,MOT.cod_motor,MOT.com_valvula,MOT.curso_pistao,
        MOT.diam_cilindro,MOT.disposicao,MOT.instalacao,MOT.peso_pot,MOT.peso_tor,MOT.pot_esp,MOT.pot_max,MOT.raz_compressao,MOT.rpm_max,MOT.rpm_pot_max,
        MOT.rpm_torque_max,MOT.torque_esp,MOT.torque_max,MOT.tuchos,MOT.valvulas,
        TRM.acoplamento,TRM.cambio,TRM.cod_cambio,TRM.marchas,TRM.tracao,TRM.reverso,
        DIM.altura,DIM.bitola_diant,DIM.bitola_tras,DIM.carga_vol,DIM.carga_peso,DIM.comprimento,DIM.entre_eixos,DIM.largura,DIM.peso,DIM.tanque,
        PNU.alt_flanco,PNU.dianteiro,PNU.traseiro,PNU.estepe,
        AER.area_front,AER.area_front_corrig,AER.coef_arrasto,
        DIR.assistencia,DIR.diam_giro,
        SUS.susp_dia,SUS.susp_tras,SUS.elem_elast_dia,SUS.elem_elast_tras,SUS.curso_susp_diant,SUS.curso_susp_tras,
        FRE.freio_dia,FRE.freio_tras,FRE.freio_aciona,FRE.abs,FRE.regenerativo,
        COM.autonomia_rod,COM.autonomia_urb
		FROM tb_veiculo AS VCL
		INNER JOIN vw_vcl_desempenho AS DES
		INNER JOIN vw_vcl_motor AS MOT
		INNER JOIN vw_vcl_transmissao AS TRM
		INNER JOIN vw_vcl_dimensao AS DIM
		INNER JOIN vw_vcl_pneus AS PNU
		INNER JOIN vw_vcl_aerodinamica AS AER
		INNER JOIN vw_vcl_direcao AS DIR
		INNER JOIN vw_vcl_suspensao AS SUS
		INNER JOIN vw_vcl_freios AS FRE
 		INNER JOIN vw_vcl_consumo AS COM
		ON DES.id = VCL.id
		AND MOT.id = VCL.id
		AND TRM.id = VCL.id
		AND DIM.id = VCL.id
		AND PNU.id = VCL.id
		AND AER.id = VCL.id
		AND DIR.id = VCL.id
		AND FRE.id = VCL.id
 		AND COM.id = VCL.id;
        
SELECT * FROM vw_veiculos;
