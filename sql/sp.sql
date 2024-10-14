 DROP PROCEDURE IF EXISTS sp_getHash;
DELIMITER $$
	CREATE PROCEDURE sp_getHash(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SELECT SHA2(CONCAT(Iemail, Isenha), 256) AS HASH;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_allow;
DELIMITER $$
	CREATE PROCEDURE sp_allow(
		IN Iallow varchar(80),
		IN Ihash varchar(64)
    )
	BEGIN    
		SET @access = (SELECT IFNULL(access,-1) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET @quer =CONCAT('SET @allow = (SELECT ',@access,' IN ',Iallow,');');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
	END $$
DELIMITER ;

/* LOGIN */

 DROP PROCEDURE IF EXISTS sp_login;
DELIMITER $$
	CREATE PROCEDURE sp_login(
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SET @hash = (SELECT SHA2(CONCAT(Iemail, Isenha), 256));
		SELECT *, IF(nome="",SUBSTRING_INDEX(email,"@",1),nome) AS nome FROM tb_usuario WHERE hash=@hash;
	END $$
DELIMITER ;

/* USER */

 DROP PROCEDURE IF EXISTS sp_setUser;
DELIMITER $$
	CREATE PROCEDURE sp_setUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid int(11),
		IN Inome varchar(30),
		IN Iemail varchar(80),
		IN Isenha varchar(30),
        IN Iaccess int(11)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iemail="")THEN
				DELETE FROM tb_mail WHERE de=Iid OR para=Iid;
				DELETE FROM tb_user WHERE id=Iid;
            ELSE			
				IF(Iid=0)THEN
					INSERT INTO tb_usuario (email,hash,access,nome)VALUES(Iemail,SHA2(CONCAT(Iemail, Isenha), 256),Iaccess,Inome);
                ELSE
					IF(Isenha="")THEN
						UPDATE tb_usuario SET access=Iaccess, nome=Inome WHERE id=Iid;
                    ELSE
						UPDATE tb_usuario SET email=Iemail, hash=SHA2(CONCAT(Iemail, Isenha), 256), access=Iaccess, nome=Inome WHERE id=Iid;
                    END IF;
                END IF;
            END IF;
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_newUser;
DELIMITER $$
	CREATE PROCEDURE sp_newUser(
		IN Inome varchar(30),
		IN Isobrenome varchar(80),
		IN Iemail varchar(80),
		IN Isenha varchar(30)
    )
	BEGIN    
		SET @has_user = (SELECT COUNT(*) FROM tb_usuario WHERE email COLLATE utf8_general_ci = Iemail = Iemail COLLATE utf8_general_ci = Iemail);
		IF(@has_user = 0)THEN
			INSERT INTO tb_usuario (email,hash,access,nome,sobrenome)VALUES(Iemail,SHA2(CONCAT(Iemail, Isenha), 256),1,Inome,Isobrenome);
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_authUser;
DELIMITER $$
	CREATE PROCEDURE sp_authUser(
		IN Iemail varchar(80)
    )
	BEGIN    
		UPDATE tb_usuario SET auth=1 WHERE email COLLATE utf8_general_ci = Iemail COLLATE utf8_general_ci;
        SELECT COUNT(*) AS auth FROM tb_usuario WHERE email COLLATE utf8_general_ci = Iemail COLLATE utf8_general_ci;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_viewUser;
DELIMITER $$
	CREATE PROCEDURE sp_viewUser(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SET @quer =CONCAT('SELECT id,email,nome,access, IF(access=0,"ROOT",IFNULL((SELECT nome FROM tb_usr_perm_perfil WHERE USR.access = id),"DESCONHECIDO")) AS perfil FROM tb_usuario AS USR WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE 
			SELECT 0 AS id, "" AS email, 0 AS access;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_updateUser;
DELIMITER $$
	CREATE PROCEDURE sp_updateUser(	
		IN Ihash varchar(64),
		IN Inome varchar(30),
        IN Isenha varchar(30)
    )
	BEGIN    
		SET @call_id = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@call_id > 0)THEN
			UPDATE tb_usuario SET hash = SHA2(CONCAT(email, Isenha), 256), nome=Inome WHERE id=@call_id;
            SELECT 1 AS ok;
		ELSE 
			SELECT 0 AS ok;
        END IF;
	END $$
DELIMITER ;

/* PERMISSÂO */

 DROP PROCEDURE IF EXISTS sp_set_usr_perm_perf;
DELIMITER $$
	CREATE PROCEDURE sp_set_usr_perm_perf(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        In Iid int(11),
		IN Inome varchar(30)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN   
			IF(Iid = 0 AND Inome != "")THEN
				INSERT INTO tb_usr_perm_perfil (nome) VALUES (Inome);
            ELSE
				IF(Inome = "")THEN
					DELETE FROM tb_usr_perm_perfil WHERE id=Iid;
				ELSE
					UPDATE tb_usr_perm_perfil SET nome = Inome WHERE id=Iid;
                END IF;
            END IF;			
			SELECT * FROM tb_usr_perm_perfil;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_view_usr_perm_perf;
DELIMITER $$
	CREATE PROCEDURE sp_view_usr_perm_perf(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN   
			SET @quer = CONCAT('SELECT * FROM tb_usr_perm_perfil WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
		ELSE 
			SELECT 0 AS id, "" AS nome;
        END IF;
	END $$
DELIMITER ;

/* CALENDAR */

 DROP PROCEDURE IF EXISTS sp_view_calendar;
DELIMITER $$
	CREATE PROCEDURE sp_view_calendar(	
		IN Ihash varchar(64),
		IN IdataIni date,
		IN IdataFin date
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SELECT * FROM tb_calendario WHERE id_user=@id_call AND data_agd>=IdataIni AND data_agd<=IdataFin;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_calendar;
DELIMITER $$
	CREATE PROCEDURE sp_set_calendar(	
		IN Ihash varchar(64),
		IN Idata date,
		IN Iobs varchar(255)
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        IF(@id_call >0)THEN
			SET @exist = (SELECT COUNT(*) FROM tb_calendario WHERE id_user=@id_call AND data_agd = Idata);
			IF(@exist AND Iobs = "")THEN
				DELETE FROM tb_calendario WHERE id_user=@id_call AND data_agd = Idata; 
			ELSE
				INSERT INTO tb_calendario (id_user, data_agd, obs) VALUES(@id_call, Idata, Iobs)
                ON DUPLICATE KEY UPDATE obs=Iobs;
			END IF;
        END IF;
	END $$
DELIMITER ;

/* MAIL */

 DROP PROCEDURE IF EXISTS sp_check_usr_mail;
DELIMITER $$
	CREATE PROCEDURE sp_check_usr_mail(
		IN Ihash varchar(64)
    )
	BEGIN
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call>0)THEN        
			SELECT COUNT(*) AS new_mail FROM tb_mail WHERE id_to = @id_call AND looked=0;
		ELSE
			SELECT 0 AS new_mail ;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_mail;
DELIMITER $$
	CREATE PROCEDURE sp_set_mail(	
		IN Ihash varchar(64),
        IN Iid_to int(11),
		IN Imessage varchar(512)
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        IF(@id_call >0)THEN
			INSERT INTO tb_mail (id_from,id_to,message) VALUES (@id_call,Iid_to,Imessage);
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_view_mail;
DELIMITER $$
	CREATE PROCEDURE sp_view_mail(	
		IN Ihash varchar(64),
        IN Isend boolean
    )
	BEGIN    
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call > 0)THEN
			IF(Isend)THEN
				SELECT MAIL.*, USR.email AS mail_from
					FROM tb_mail AS MAIL 
					INNER JOIN tb_usuario AS USR
					ON MAIL.id_from = USR.id AND MAIL.id_to = @id_call;            
            ELSE
				SELECT MAIL.*, USR.email AS mail_to
					FROM tb_mail AS MAIL 
					INNER JOIN tb_usuario AS USR
					ON MAIL.id_to = USR.id AND MAIL.id_from = @id_call;            
            END IF;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_del_mail;
DELIMITER $$
	CREATE PROCEDURE sp_del_mail(	
		IN Ihash varchar(64),
        IN Idata datetime,
        IN Iid_from int(11),
        IN Iid_to int(11)
    )
	BEGIN        
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call = Iid_to OR @id_call = Iid_from)THEN
			DELETE FROM tb_mail WHERE data = Idata AND id_from = Iid_from AND id_to = Iid_to;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_mark_mail;
DELIMITER $$
	CREATE PROCEDURE sp_mark_mail(	
		IN Ihash varchar(64),
        IN Idata datetime,
        IN Iid_from int(11),
        IN Iid_to int(11)
    )
	BEGIN        
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@id_call = Iid_to OR @id_call = Iid_from)THEN
			UPDATE tb_mail SET looked=1 WHERE data = Idata AND id_from = Iid_from AND id_to = Iid_to;
        END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_all_mail_adress;
DELIMITER $$
	CREATE PROCEDURE sp_all_mail_adress(	
		IN Ihash varchar(64)
    )
	BEGIN
		SET @id_call = (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SELECT id,email FROM tb_usuario WHERE id != @id_call ORDER BY email ASC;
	END $$
DELIMITER ;

/* POSTS */

 DROP PROCEDURE IF EXISTS sp_view_post;
DELIMITER $$
	CREATE PROCEDURE sp_view_post(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Idate datetime,
		IN Istart int(11) unsigned,
		IN Iend int(11) unsigned
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SELECT * FROM vw_post WHERE data_hora >= Idate ORDER BY data_hora LIMIT Istart,Iend;
		END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_post;
DELIMITER $$
	CREATE PROCEDURE sp_set_post(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Itexto varchar(255)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		SET @id_user =  (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@allow AND @id_user>0)THEN
			IF(Itexto="#del")THEN
				DELETE FROM tb_post_like WHERE id_post=Iid;
				DELETE FROM tb_post_view WHERE id_post=Iid;
				DELETE FROM tb_post_message WHERE id_post=Iid;
				DELETE FROM tb_post WHERE id=Iid;
                SELECT "DEL" AS resp;
            ELSE			
				IF(Iid=0)THEN
					INSERT INTO tb_post (id_user,texto)
                    VALUES(@id_user,Itexto);            
					SELECT "NEW" AS resp;
                ELSE
					UPDATE tb_post SET edited=1, texto=Itexto WHERE id=Iid;
					SELECT "UPD" AS resp;
                END IF;
            END IF;
		ELSE
			SELECT "NTH" AS resp;
        END IF;
	END $$
DELIMITER ;
/* ACERVO */

 DROP PROCEDURE IF EXISTS sp_view_acervo;
DELIMITER $$
	CREATE PROCEDURE sp_view_acervo(	
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Inome varchar(30)
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SELECT * FROM vw_acervo WHERE nome COLLATE utf8_general_ci LIKE CONCAT('%',Inome,'%') COLLATE utf8_general_ci ORDER BY nome;
		END IF;
	END $$
DELIMITER ;

 DROP PROCEDURE IF EXISTS sp_set_acervo;
DELIMITER $$
	CREATE PROCEDURE sp_set_acervo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Iid_owner int(11),
		IN Inome varchar(30)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		SET @id_user =  (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@allow AND @id_user>0)THEN
			IF(Inome="")THEN
				DELETE FROM tb_acervo WHERE id=Iid;
            ELSE			
				IF(Iid=0)THEN
					INSERT INTO tb_acervo (id_owner,nome)
                    VALUES(@id_user,Inome);            
                ELSE
					UPDATE tb_acervo SET nome=Inome, id_owner=Iid_owner WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

/* VEÍCULO */
 
  DROP PROCEDURE IF EXISTS sp_view_veiculo;
DELIMITER $$
	CREATE PROCEDURE sp_view_veiculo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_acervo int(11),
		IN Ifield varchar(30),
        IN Isignal varchar(4),
		IN Ivalue varchar(50)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iid_acervo=0)THEN
				SET @quer =CONCAT('SELECT * FROM vw_veiculos WHERE ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
            ELSE
				SET @quer =CONCAT('SELECT * FROM vw_veiculos WHERE id_acervo=',Iid_acervo ,' AND ',Ifield,' ',Isignal,' ',Ivalue,' ORDER BY ',Ifield,';');
            END IF;
			PREPARE stmt1 FROM @quer;
			EXECUTE stmt1;
        END IF;
	END $$
DELIMITER ;
 
   DROP PROCEDURE IF EXISTS sp_new_veiculo;
DELIMITER $$
	CREATE PROCEDURE sp_new_veiculo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
        IN Iid_acervo int(11),
		IN Inome varchar(30)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			INSERT INTO tb_veiculo (id_acervo,nome) VALUES (Iid_acervo,Inome);
        END IF;
	END $$
DELIMITER ;
 
  DROP PROCEDURE IF EXISTS sp_set_veiculo;
DELIMITER $$
	CREATE PROCEDURE sp_set_veiculo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
        IN Iid_acervo int(11),
		IN Inome varchar(30),
        IN Iano int,
		IN Imodelo varchar(50),
		IN Imarca varchar(50),
		IN Icombustivel varchar(20),
		IN Iconfiguracao varchar(15),
		IN Iportas int,
		IN Ilugares int,
		IN Iporte varchar(15),
		IN Iplaca varchar(15),
		IN Iprocedencia varchar(25)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				DELETE FROM tb_veiculo WHERE id=Iid;
            ELSE			
				IF(Iid=0)THEN
					INSERT INTO tb_veiculo (id_acervo,nome,ano,modelo,marca,combustivel,configuracao,portas,lugares,porte,placa,procedencia)
                    VALUES(Iid_acervo,Inome,Iano,Imodelo,Imarca,Icombustivel,Iconfiguracao,Iportas,Ilugares,Iporte,Iplaca,Iprocedencia);            
                ELSE
					UPDATE tb_veiculo SET nome=Inome,ano=Iano,modelo=Imodelo,marca=Imarca,combustivel=Icombustivel,
                    configuracao=Iconfiguracao,portas=Iportas,lugares=Ilugares,porte=Iporte,placa=Iplaca,procedencia=Iprocedencia
                    WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;


/* EQUIPAMENTO */

  DROP PROCEDURE IF EXISTS sp_view_equip;
DELIMITER $$
	CREATE PROCEDURE sp_view_equip(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iequip varchar(50),
		IN Isessao varchar(20)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			SELECT * FROM tb_equipamento 
            WHERE equip LIKE CONCAT('%',Iequip,'%') COLLATE utf8_general_ci 
            AND sessao LIKE CONCAT('%',Isessao,'%') COLLATE utf8_general_ci
            ORDER BY sessao,equip;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_equip;
DELIMITER $$
	CREATE PROCEDURE sp_set_equip(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid int(11),
		IN Iequip varchar(50),
		IN Isessao varchar(20)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iequip="")THEN
				DELETE FROM tb_equipamento WHERE id=Iid;
            ELSE			
				IF(Iid=0)THEN
					INSERT INTO tb_equipamento (equip,sessao)
                    VALUES(Iequip,Isessao);            
                ELSE
					UPDATE tb_equipamento SET equip=Iequip, sessao=Isessao
                    WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_desempenho;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_desempenho(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Iace_0_100 double,
		IN Ivel_max double
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);        
		IF(@allow)THEN
			IF(Iace_0_100<=0)THEN
				DELETE FROM tb_vcl_desempenho WHERE id=Iid;
            ELSE
				INSERT INTO tb_vcl_desempenho (id_vcl,ace_0_100,vel_max)
				VALUES(Iid_vcl,Iace_0_100,Ivel_max)
				ON DUPLICATE KEY UPDATE
				ace_0_100=Iace_0_100, vel_max=Ivel_max;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_motor;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_motor(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Iaci_comando varchar(20),
		IN Ialimentacao varchar(20),
		IN Iaspiracao double,
		IN Icilindrada int,
		IN Icilindros int,
		IN Icod_motor varchar(20),
		IN Icom_valvula varchar(20),
		IN Icurso_pistao double,
		IN Idiam_cilindro double,
		IN Idisposicao varchar(20),
		IN Iinstalacao varchar(20),
		IN Ipeso_pot double,
		IN Ipot_max double,
		IN Iraz_compressao varchar(20),
		IN Irpm_max double,
		IN Irpm_pot_max double,
		IN Irpm_torque_max double,
		IN Itorque_esp varchar(20),
		IN Itorque_max varchar(40),
		IN Ituchos varchar(20),
		IN Ivalv_cilindros int
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);        
		IF(@allow)THEN
			IF(Icilindros<=0)THEN
				DELETE FROM tb_vcl_desempenho WHERE id=Iid;
            ELSE
				INSERT INTO tb_vcl_desempenho (id_vcl,aci_comando,alimentacao,aspiracao,cilindrada,cilindros,cod_motor,com_valvula,
                curso_pistao,diam_cilindro,disposicao,instalacao,peso_pot,pot_max,raz_compressao,rpm_max,rpm_pot_max,rpm_torque_max,
                torque_esp,torque_max,tuchos,valv_cilindros)
				VALUES(Iid_vcl,Iaci_comando,Ialimentacao,Iaspiracao,Icilindrada,Icilindros,Icod_motor,Icom_valvula,
                Icurso_pistao,Idiam_cilindro,Idisposicao,Iinstalacao,Ipeso_pot,Ipot_max,Iraz_compressao,Irpm_max,Irpm_pot_max,Irpm_torque_max,
                Itorque_esp,Itorque_max,Ituchos,Ivalv_cilindros)
				ON DUPLICATE KEY UPDATE
				aci_comando=Iaci_comando,alimentacao=Ialimentacao,aspiracao=Iaspiracao,cilindrada=Icilindrada,cilindros=Icilindros,
                cod_motor=Icod_motor,com_valvula=Icom_valvula,curso_pistao=Icurso_pistao,diam_cilindro=Idiam_cilindro,disposicao=Idisposicao,
                instalacao=Iinstalacao,peso_pot=Ipeso_pot,pot_max=Ipot_max,raz_compressao=Iraz_compressao,rpm_max=Irpm_max,rpm_pot_max=Irpm_pot_max,
                rpm_torque_max=Irpm_torque_max,torque_esp=Itorque_esp,torque_max=Itorque_max,tuchos=Ituchos,valv_cilindros=Ivalv_cilindros;
            END IF;
        END IF;
	END $$
DELIMITER ;