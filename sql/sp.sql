/* IF NULL */

	 DROP PROCEDURE IF EXISTS sp_teste;
DELIMITER $$
	CREATE PROCEDURE sp_teste(
		IN Itext double
    )
	BEGIN    
		SET Itext = (SELECT IF(Itext=0,NULL,Itext));
        SELECT Itext AS saida;
	END $$
DELIMITER ;
	

    CALL sp_teste("");
    
    SELECT IF(1="",NULL,2) AS ok;

/*  */
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
			SELECT * FROM vw_post WHERE data_hora >= Idate ORDER BY data_hora ASC LIMIT Istart,Iend;
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

 DROP PROCEDURE IF EXISTS sp_new_acervo;
DELIMITER $$
	CREATE PROCEDURE sp_new_acervo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Inome varchar(30)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		SET @id_user =  (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@allow AND @id_user>0)THEN
			INSERT INTO tb_acervo (id_owner,nome) VALUES (@id_user,Inome);
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
		IN Inome varchar(30),
		IN Iurl varchar(30),
        IN Ifrase varchar(255),
		IN Itelefone varchar(15),
		IN Iemail varchar(100),
		IN Ifacebook varchar(100),
		IN Iyoutube varchar(100),
		IN Iinstagram varchar(100),
		IN Iwhatsapp varchar(15)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		SET @id_user =  (SELECT IFNULL(id,0) FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		IF(@allow AND @id_user>0)THEN
			IF(Inome="")THEN
				CALL sp_del_acervo(Iallow,Ihash,Iid);
-- 				DELETE FROM tb_vcl_desempenho WHERE
-- 				DELETE FROM tb_veiculo WHERE id_acervo=Iid;
-- 				DELETE FROM tb_acervo WHERE id=Iid;                
            ELSE
				SET Iurl = (SELECT IF(TRIM(Iurl)="",(SELECT NULL),Iurl));
				SET Ifrase = (SELECT IF(TRIM(Ifrase)="",(SELECT NULL),Ifrase));
				SET Itelefone = (SELECT IF(TRIM(Itelefone)="",(SELECT NULL),Itelefone));
				SET Iemail = (SELECT IF(TRIM(Iemail)="",(SELECT NULL),Iemail));
				SET Ifacebook = (SELECT IF(TRIM(Ifacebook)="",(SELECT NULL),Ifacebook));
				SET Iyoutube = (SELECT IF(TRIM(Iyoutube)="",(SELECT NULL),Iyoutube));
				SET Iinstagram = (SELECT IF(TRIM(Iinstagram)="",(SELECT NULL),Iinstagram));
				SET Iwhatsapp = (SELECT IF(TRIM(Iwhatsapp)="",(SELECT NULL),Iwhatsapp));

				IF(Iid=0)THEN
					INSERT INTO tb_acervo (id_owner,nome,url)
                    VALUES(@id_user,Inome,Iurl);            
                ELSE
					UPDATE tb_acervo 
                    SET nome=Inome,id_owner=Iid_owner,url=Iurl,frase=Ifrase,telefone=Itelefone,email=Iemail,
						facebook=Ifacebook,youtube=Iyoutube,instagram=Iinstagram,whatsapp=Iwhatsapp
                    WHERE id=Iid;
                END IF;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_del_acervo;
DELIMITER $$
	CREATE PROCEDURE sp_del_acervo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_acervo int(11)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			DELETE tb_vcl_desempenho FROM tb_vcl_desempenho INNER JOIN tb_veiculo ON tb_vcl_desempenho.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_motor FROM tb_vcl_motor INNER JOIN tb_veiculo ON tb_vcl_motor.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_transmissao FROM tb_vcl_transmissao INNER JOIN tb_veiculo ON tb_vcl_transmissao.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_dimensao FROM tb_vcl_dimensao INNER JOIN tb_veiculo ON tb_vcl_dimensao.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_pneus FROM tb_vcl_pneus INNER JOIN tb_veiculo ON tb_vcl_pneus.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_direcao FROM tb_vcl_direcao INNER JOIN tb_veiculo ON tb_vcl_direcao.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_suspensao FROM tb_vcl_suspensao INNER JOIN tb_veiculo ON tb_vcl_suspensao.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_freios FROM tb_vcl_freios INNER JOIN tb_veiculo ON tb_vcl_freios.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_consumo FROM tb_vcl_consumo INNER JOIN tb_veiculo ON tb_vcl_consumo.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE tb_vcl_equip FROM tb_vcl_equip  INNER JOIN tb_veiculo ON tb_vcl_equip.id_vcl = tb_veiculo.id WHERE tb_veiculo.id_acervo = Iid_acervo;
            DELETE FROM tb_veiculo WHERE id_acervo = Iid_acervo;
            DELETE FROM tb_acervo WHERE id = Iid_acervo;
        END IF;
	END $$
DELIMITER ;

/* VEÍCULO */
 
  DROP PROCEDURE IF EXISTS sp_del_veiculo;
DELIMITER $$
	CREATE PROCEDURE sp_del_veiculo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_veiculo int(11)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			DELETE FROM tb_vcl_desempenho WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_motor WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_transmissao WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_dimensao WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_pneus WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_aerodinamica WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_direcao WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_suspensao WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_freios WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_consumo WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_vcl_equip WHERE id_vcl = Iid_veiculo;
            DELETE FROM tb_veiculo WHERE id = Iid_veiculo;
        END IF;
	END $$
DELIMITER ;
 
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
		IN Iprocedencia varchar(25),
		IN Idescricao varchar(256)
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Inome="")THEN
				CALL sp_del_veiculo(Iallow,Ihash,Iid);
-- 				DELETE FROM tb_veiculo WHERE id=Iid;
            ELSE
				SET Inome = (SELECT IF(TRIM(Inome)="",(SELECT NULL),Inome));
				SET Imodelo = (SELECT IF(TRIM(Imodelo)="",(SELECT NULL),Imodelo));
				SET Imarca = (SELECT IF(TRIM(Imarca)="",(SELECT NULL),Imarca));
				SET Icombustivel = (SELECT IF(TRIM(Icombustivel)="",(SELECT NULL),Icombustivel));
				SET Iconfiguracao = (SELECT IF(TRIM(Iconfiguracao)="",(SELECT NULL),Iconfiguracao));
				SET Iporte = (SELECT IF(TRIM(Iporte)="",(SELECT NULL),Iporte));
				SET Iplaca = (SELECT IF(TRIM(Iplaca)="",(SELECT NULL),Iplaca));
				SET Iprocedencia = (SELECT IF(TRIM(Iprocedencia)="",(SELECT NULL),Iprocedencia));
				SET Idescricao = (SELECT IF(TRIM(Idescricao)="",(SELECT NULL),Idescricao));

				SET Iano = (SELECT IF(Iano=0,(SELECT NULL),Iano));
				SET Iportas = (SELECT IF(Iportas=0,(SELECT NULL),Iportas));
				SET Ilugares = (SELECT IF(Ilugares=0,(SELECT NULL),Ilugares));

				UPDATE tb_veiculo SET nome=Inome,ano=Iano,modelo=Imodelo,marca=Imarca,combustivel=Icombustivel,
				configuracao=Iconfiguracao,portas=Iportas,lugares=Ilugares,porte=Iporte,placa=Iplaca,
                procedencia=Iprocedencia,descricao=Idescricao
				WHERE id=Iid;
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
			IF(Iace_0_100<0)THEN
				DELETE FROM tb_vcl_desempenho WHERE id_vcl=Iid_vcl;
            ELSE
				SET Iace_0_100 = (SELECT IF(Iace_0_100=0,(SELECT NULL),Iace_0_100));
				SET Ivel_max = (SELECT IF(Ivel_max=0,(SELECT NULL),Ivel_max));
            
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
		IN Iaspiracao varchar(20),
		IN Icilindrada int,
		IN Icilindros int,
		IN Icod_motor varchar(20),
		IN Icom_valvula varchar(20),
		IN Icurso_pistao double,
		IN Idiam_cilindro double,
		IN Idisposicao varchar(20),
		IN Iinstalacao varchar(20),
		IN Ipeso_pot double,
		IN Ipeso_tor double,
		IN Ipot_esp double,
		IN Ipot_max double,
		IN Iraz_compressao varchar(20),
		IN Irpm_max double,
		IN Irpm_pot_max double,
		IN Irpm_torque_max double,
		IN Itorque_esp double,
		IN Itorque_max double,
		IN Ituchos varchar(20),
		IN Ivalvulas int
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);        
		IF(@allow)THEN
			IF(Icilindros<0)THEN
				DELETE FROM tb_vcl_motor WHERE id_vcl=Iid_vcl;
            ELSE
				SET Iaci_comando = (SELECT IF(TRIM(Iaci_comando)="",(SELECT NULL),Iaci_comando));
				SET Ialimentacao = (SELECT IF(TRIM(Ialimentacao)="",(SELECT NULL),Ialimentacao));
				SET Iaspiracao = (SELECT IF(TRIM(Iaspiracao)="",(SELECT NULL),Iaspiracao));
				SET Icod_motor = (SELECT IF(TRIM(Icod_motor)="",(SELECT NULL),Icod_motor));
				SET Icom_valvula = (SELECT IF(TRIM(Icom_valvula)="",(SELECT NULL),Icom_valvula));
				SET Idisposicao = (SELECT IF(TRIM(Idisposicao)="",(SELECT NULL),Idisposicao));
				SET Iinstalacao = (SELECT IF(TRIM(Iinstalacao)="",(SELECT NULL),Iinstalacao));
				SET Iraz_compressao = (SELECT IF(TRIM(Iraz_compressao)="",(SELECT NULL),Iraz_compressao));
				SET Ituchos = (SELECT IF(TRIM(Ituchos)="",(SELECT NULL),Ituchos));

				SET Icilindrada = (SELECT IF(Icilindrada=0,(SELECT NULL),Icilindrada));
				SET Icilindros = (SELECT IF(Icilindros=0,(SELECT NULL),Icilindros));
				SET Icurso_pistao = (SELECT IF(Icurso_pistao=0,(SELECT NULL),Icurso_pistao));
				SET Idiam_cilindro = (SELECT IF(Idiam_cilindro=0,(SELECT NULL),Idiam_cilindro));
				SET Ipeso_pot = (SELECT IF(Ipeso_pot=0,(SELECT NULL),Ipeso_pot));
				SET Ipeso_tor = (SELECT IF(Ipeso_tor=0,(SELECT NULL),Ipeso_tor));
				SET Ipot_esp = (SELECT IF(Ipot_esp=0,(SELECT NULL),Ipot_esp));
				SET Ipot_max = (SELECT IF(Ipot_max=0,(SELECT NULL),Ipot_max));
				SET Irpm_max = (SELECT IF(Irpm_max=0,(SELECT NULL),Irpm_max));
				SET Irpm_pot_max = (SELECT IF(Irpm_pot_max=0,(SELECT NULL),Irpm_pot_max));
				SET Irpm_torque_max = (SELECT IF(Irpm_torque_max=0,(SELECT NULL),Irpm_torque_max));
				SET Itorque_esp = (SELECT IF(Itorque_esp=0,(SELECT NULL),Itorque_esp));
				SET Itorque_max = (SELECT IF(Itorque_max=0,(SELECT NULL),Itorque_max));
				SET Ivalvulas = (SELECT IF(Ivalvulas=0,(SELECT NULL),Ivalvulas));

				INSERT INTO tb_vcl_motor (id_vcl,aci_comando,alimentacao,aspiracao,cilindrada,cilindros,cod_motor,com_valvula,
                curso_pistao,diam_cilindro,disposicao,instalacao,peso_pot,peso_tor,pot_esp,pot_max,raz_compressao,rpm_max,rpm_pot_max,
                rpm_torque_max,torque_esp,torque_max,tuchos,valvulas)
				VALUES(Iid_vcl,Iaci_comando,Ialimentacao,Iaspiracao,Icilindrada,Icilindros,Icod_motor,Icom_valvula,
                Icurso_pistao,Idiam_cilindro,Idisposicao,Iinstalacao,Ipeso_pot,Ipeso_tor,Ipot_esp,Ipot_max,Iraz_compressao,
                Irpm_max,Irpm_pot_max,Irpm_torque_max,Itorque_esp,Itorque_max,Ituchos,Ivalvulas)
				ON DUPLICATE KEY UPDATE
				aci_comando=Iaci_comando,alimentacao=Ialimentacao,aspiracao=Iaspiracao,cilindrada=Icilindrada,cilindros=Icilindros,
                cod_motor=Icod_motor,com_valvula=Icom_valvula,curso_pistao=Icurso_pistao,diam_cilindro=Idiam_cilindro,disposicao=Idisposicao,
                instalacao=Iinstalacao,peso_pot=Ipeso_pot,peso_tor=Ipeso_tor,pot_esp=Ipot_esp,pot_max=Ipot_max,raz_compressao=Iraz_compressao,rpm_max=Irpm_max,rpm_pot_max=Irpm_pot_max,
                rpm_torque_max=Irpm_torque_max,torque_esp=Itorque_esp,torque_max=Itorque_max,tuchos=Ituchos,valvulas=Ivalvulas;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_transmissao;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_transmissao(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Iacoplamento varchar(20),
		IN Icambio varchar(20),
		IN Icod_cambio varchar(20),
		IN Imarchas int,
		IN Itracao varchar(20),
        IN Ireverso boolean
    )
	BEGIN    
		CALL sp_allow(Iallow,Ihash);        
		IF(@allow)THEN
			IF(Imarchas<0)THEN
				DELETE FROM tb_vcl_transmissao WHERE id_vcl=Iid_vcl;
            ELSE
				SET Imarchas = (SELECT IF(Imarchas=0,(SELECT NULL),Imarchas));

				SET Iacoplamento = (SELECT IF(TRIM(Iacoplamento)="",(SELECT NULL),Iacoplamento));
				SET Icambio = (SELECT IF(TRIM(Icambio)="",(SELECT NULL),Icambio));
				SET Icod_cambio = (SELECT IF(TRIM(Icod_cambio)="",(SELECT NULL),Icod_cambio));
				SET Itracao = (SELECT IF(TRIM(Itracao)="",(SELECT NULL),Itracao));
            
				INSERT INTO tb_vcl_transmissao (id_vcl,acoplamento,cambio,cod_cambio,marchas,tracao,reverso)
				VALUES(Iid_vcl,Iacoplamento,Icambio,Icod_cambio,Imarchas,Itracao,Ireverso)
				ON DUPLICATE KEY UPDATE
				acoplamento=Iacoplamento,cambio=Icambio,cod_cambio=Icod_cambio,marchas=Imarchas,tracao=Itracao;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_dimensao;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_dimensao(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Ialtura double,
		IN Ibitola_diant double,
		IN Ibitola_tras double,
		IN Icarga_vol double,
		IN Icarga_peso double,
		IN Icomprimento double,
		IN Ientre_eixos double,
		IN Ilargura double,
		IN Ipeso double,
		IN Itanque double
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Ialtura<0)THEN
				DELETE FROM tb_vcl_dimensao WHERE id_vcl=Iid_vcl;
            ELSE
				SET Ialtura = (SELECT IF(Ialtura=0,(SELECT NULL),Ialtura));
				SET Ibitola_diant = (SELECT IF(Ibitola_diant=0,(SELECT NULL),Ibitola_diant));
				SET Ibitola_tras = (SELECT IF(Ibitola_tras=0,(SELECT NULL),Ibitola_tras));
				SET Icarga_vol = (SELECT IF(Icarga_vol=0,(SELECT NULL),Icarga_vol));
				SET Icarga_peso = (SELECT IF(Icarga_peso=0,(SELECT NULL),Icarga_peso));
				SET Icomprimento = (SELECT IF(Icomprimento=0,(SELECT NULL),Icomprimento));
				SET Ientre_eixos = (SELECT IF(Ientre_eixos=0,(SELECT NULL),Ientre_eixos));
				SET Ilargura = (SELECT IF(Ilargura=0,(SELECT NULL),Ilargura));
				SET Ipeso = (SELECT IF(Ipeso=0,(SELECT NULL),Ipeso));
				SET Itanque = (SELECT IF(Itanque=0,(SELECT NULL),Itanque));

				INSERT INTO tb_vcl_dimensao (id_vcl,altura,bitola_diant,bitola_tras,carga_vol,carga_peso,comprimento,entre_eixos,largura,peso,tanque)
				VALUES(Iid_vcl,Ialtura,Ibitola_diant,Ibitola_tras,Icarga_vol,Icarga_peso,Icomprimento,Ientre_eixos,Ilargura,Ipeso,Itanque)
				ON DUPLICATE KEY UPDATE
				altura=Ialtura,bitola_diant=Ibitola_diant,bitola_tras=Ibitola_tras,carga_vol=Icarga_vol,carga_peso=Icarga_peso,
                comprimento=Icomprimento,entre_eixos=Ientre_eixos,largura=Ilargura,peso=Ipeso,tanque=Itanque;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_pneu;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_pneu(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Ialt_flanco double,
		IN Idianteiro varchar(20),
		IN Itraseiro varchar(20),
		IN Iestepe varchar(20)
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Ialt_flanco<0)THEN
				DELETE FROM tb_vcl_pneus WHERE id_vcl=Iid_vcl;
            ELSE
				SET Ialt_flanco = (SELECT IF(Ialt_flanco=0,(SELECT NULL),Ialt_flanco));

				SET Idianteiro = (SELECT IF(TRIM(Idianteiro)="",(SELECT NULL),Idianteiro));
				SET Itraseiro = (SELECT IF(TRIM(Itraseiro)="",(SELECT NULL),Itraseiro));
				SET Iestepe = (SELECT IF(TRIM(Iestepe)="",(SELECT NULL),Iestepe));
                
				INSERT INTO tb_vcl_pneus (id_vcl,alt_flanco,dianteiro,traseiro,estepe)
				VALUES(Iid_vcl,Ialt_flanco,Idianteiro,Itraseiro,Iestepe)
				ON DUPLICATE KEY UPDATE
				alt_flanco=Ialt_flanco,dianteiro=Idianteiro,traseiro=Itraseiro,estepe=Iestepe;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_aero;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_aero(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Iarea_front double,
		IN Iarea_front_corrig double,
		IN Icoef_arrasto double
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iarea_front<0)THEN
				DELETE FROM tb_vcl_aerodinamica WHERE id_vcl=Iid_vcl;
            ELSE
				SET Iarea_front = (SELECT IF(Iarea_front=0,(SELECT NULL),Iarea_front));
				SET Iarea_front_corrig = (SELECT IF(Iarea_front_corrig=0,(SELECT NULL),Iarea_front_corrig));
				SET Icoef_arrasto = (SELECT IF(Icoef_arrasto=0,(SELECT NULL),Icoef_arrasto));

				INSERT INTO tb_vcl_aerodinamica (id_vcl,area_front,area_front_corrig,coef_arrasto)
				VALUES(Iid_vcl,Iarea_front,Iarea_front_corrig,Icoef_arrasto)
				ON DUPLICATE KEY UPDATE
				area_front=Iarea_front,area_front_corrig=Iarea_front_corrig,coef_arrasto=Icoef_arrasto;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_direcao;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_direcao(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Iassistencia varchar(20),
		IN Idiam_giro double
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Idiam_giro<0)THEN
				DELETE FROM tb_vcl_direcao WHERE id_vcl=Iid_vcl;
            ELSE
				SET Idiam_giro = (SELECT IF(Idiam_giro=0,(SELECT NULL),Idiam_giro));
				SET Iassistencia = (SELECT IF(TRIM(Iassistencia)="",(SELECT NULL),Iassistencia));

				INSERT INTO tb_vcl_direcao (id_vcl,assistencia,diam_giro)
				VALUES(Iid_vcl,Iassistencia,Idiam_giro)
				ON DUPLICATE KEY UPDATE
				assistencia=Iassistencia,diam_giro=Idiam_giro;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_susp;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_susp(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Isusp_dia varchar(20),
		IN Isusp_tras varchar(20),
		IN Ielem_elast_dia varchar(20),
		IN Ielem_elast_tras varchar(20),
		IN Icurso_susp_diant double,
		IN Icurso_susp_tras double
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Icurso_susp_diant<0)THEN
				DELETE FROM tb_vcl_suspensao WHERE id_vcl=Iid_vcl;
            ELSE
				SET Icurso_susp_diant = (SELECT IF(Icurso_susp_diant=0,(SELECT NULL),Icurso_susp_diant));
				SET Icurso_susp_tras = (SELECT IF(Icurso_susp_tras=0,(SELECT NULL),Icurso_susp_tras));
            
				SET Isusp_dia = (SELECT IF(TRIM(Isusp_dia)="",(SELECT NULL),Isusp_dia));
				SET Isusp_tras = (SELECT IF(TRIM(Isusp_tras)="",(SELECT NULL),Isusp_tras));
				SET Ielem_elast_dia = (SELECT IF(TRIM(Ielem_elast_dia)="",(SELECT NULL),Ielem_elast_dia));
				SET Ielem_elast_tras = (SELECT IF(TRIM(Ielem_elast_tras)="",(SELECT NULL),Ielem_elast_tras));
-- SELECT Iid_vcl,Isusp_dia,Isusp_tras,Ielem_elast_dia,Ielem_elast_tras,Icurso_susp_diant,Icurso_susp_tras;

				INSERT INTO tb_vcl_suspensao (id_vcl,susp_dia,susp_tras,elem_elast_dia,elem_elast_tras,curso_susp_diant,curso_susp_tras)
				VALUES(Iid_vcl,Isusp_dia,Isusp_tras,Ielem_elast_dia,Ielem_elast_tras,Icurso_susp_diant,Icurso_susp_tras)
				ON DUPLICATE KEY UPDATE
				susp_dia=Isusp_dia,susp_tras=Isusp_tras,elem_elast_dia=Ielem_elast_dia,elem_elast_tras=Ielem_elast_tras,
                curso_susp_diant=Icurso_susp_diant,curso_susp_tras=Icurso_susp_tras;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_freio;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_freio(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Ifreio_dia varchar(20),
		IN Ifreio_tras varchar(20),
		IN Ifreio_aciona varchar(20),
		IN Iabs boolean,
		IN Iregenerativo boolean
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Ifreio_dia="#DEL")THEN
				DELETE FROM tb_vcl_freios WHERE id_vcl=Iid_vcl;
            ELSE
				SET Iabs = (SELECT IF(Iabs=0,(SELECT NULL),Iabs));
				SET Iregenerativo = (SELECT IF(Iregenerativo=0,(SELECT NULL),Iregenerativo));

				SET Ifreio_dia = (SELECT IF(TRIM(Ifreio_dia)="",(SELECT NULL),Ifreio_dia));
				SET Ifreio_tras = (SELECT IF(TRIM(Ifreio_tras)="",(SELECT NULL),Ifreio_tras));
				SET Ifreio_aciona = (SELECT IF(TRIM(Ifreio_aciona)="",(SELECT NULL),Ifreio_aciona));

				INSERT INTO tb_vcl_freios (id_vcl,freio_dia,freio_tras,freio_aciona,abs,regenerativo)
				VALUES(Iid_vcl,Ifreio_dia,Ifreio_tras,Ifreio_aciona,Iabs,Iregenerativo)
				ON DUPLICATE KEY UPDATE
				freio_dia=Ifreio_dia,freio_tras=Ifreio_tras,freio_aciona=Ifreio_aciona,abs=Iabs,regenerativo=Iregenerativo;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_consumo;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_consumo(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
		IN Iautonomia_rod double,
		IN Iautonomia_urb double
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iautonomia_rod<0)THEN
				DELETE FROM tb_vcl_consumo WHERE id_vcl=Iid_vcl;
            ELSE
				SET Iautonomia_rod = (SELECT IF(Iautonomia_rod=0,(SELECT NULL),Iautonomia_rod));
				SET Iautonomia_urb = (SELECT IF(Iautonomia_urb=0,(SELECT NULL),Iautonomia_urb));

				INSERT INTO tb_vcl_consumo (id_vcl,autonomia_rod,autonomia_urb)
				VALUES(Iid_vcl,Iautonomia_rod,Iautonomia_urb)
				ON DUPLICATE KEY UPDATE
				autonomia_rod=Iautonomia_rod,autonomia_urb=Iautonomia_urb;
            END IF;
        END IF;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_view_vcl_equip;
DELIMITER $$
	CREATE PROCEDURE sp_view_vcl_equip(
		IN Iid_vcl int(11)
    )
	BEGIN
		SELECT EQP.*, IF(COALESCE(VCL.id_equip,0),1,0) AS tem
		FROM tb_equipamento AS EQP
		LEFT JOIN tb_vcl_equip AS VCL
		ON VCL.id_equip = EQP.id
		AND VCL.id_vcl = Iid_vcl;
	END $$
DELIMITER ;

  DROP PROCEDURE IF EXISTS sp_set_vcl_equip;
DELIMITER $$
	CREATE PROCEDURE sp_set_vcl_equip(
		IN Iallow varchar(80),
		IN Ihash varchar(64),
		IN Iid_vcl int(11),
        IN Iid_equip int(11),
        IN Iadd boolean
    )
	BEGIN
		CALL sp_allow(Iallow,Ihash);
		IF(@allow)THEN
			IF(Iadd)THEN
				INSERT INTO tb_vcl_equip (id_vcl,id_equip) VALUES (Iid_vcl,Iid_equip);
            ELSE
				DELETE FROM tb_vcl_equip WHERE id_vcl=Iid_vcl AND id_equip=Iid_equip;
            END IF;
        END IF;
	END $$
DELIMITER ;