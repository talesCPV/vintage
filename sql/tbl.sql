/* TABELAS */

 DROP TABLE IF EXISTS tb_usuario;
CREATE TABLE tb_usuario (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(70) NOT NULL,
    hash varchar(64) NOT NULL,
    nome varchar(30) NOT NULL DEFAULT "",
    sobrenome varchar(80) NOT NULL DEFAULT "",
    auth boolean DEFAULT 0,
    access int(11) DEFAULT -1,
	UNIQUE KEY (hash),
	UNIQUE KEY (email),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 INSERT INTO tb_usuario (email,hash,access,nome)VALUES("admin@planet3.com.br","af67057179cb1e8fbefdfb19411dccb7b472afc2ff6884d5f5b9a9eec717d239",0,"Developer");
-- usuario: admin@planet3.com.br
-- senha: 123456

 DROP TABLE IF EXISTS tb_usr_perm_perfil;
CREATE TABLE tb_usr_perm_perfil (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(30) NOT NULL,
    perm varchar(50) NOT NULL DEFAULT "0",
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_mail;
CREATE TABLE tb_mail (
	data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    id_from int(11) NOT NULL,
    id_to int(11) NOT NULL,
    message varchar(1000),
    looked boolean DEFAULT 0,
    FOREIGN KEY (id_from) REFERENCES tb_usuario(id),
    FOREIGN KEY (id_to) REFERENCES tb_usuario(id),
    PRIMARY KEY (data,id_from)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_calendario;
CREATE TABLE tb_calendario (
    id_user int(11) NOT NULL,
    data_agd date NOT NULL,
    obs varchar(255),
    PRIMARY KEY (id_user,data_agd)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

/* FIM PADRÃO */
/* POSTS */

 DROP TABLE IF EXISTS tb_post;
CREATE TABLE tb_post(
	id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id_user int(11) NOT NULL,
    data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    texto varchar(255),
    edited boolean DEFAULT 0,
    FOREIGN KEY (id) REFERENCES tb_usuario(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_post_like;
CREATE TABLE tb_post_like(
    id_user int(11) NOT NULL,
    id_post int(11) NOT NULL,
    FOREIGN KEY (id_user) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_post) REFERENCES tb_post(id),
    PRIMARY KEY (id_user,id_post)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_post_view;
CREATE TABLE tb_post_view(
    id_user int(11) NOT NULL,
    id_post int(11) NOT NULL,
    FOREIGN KEY (id_user) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_post) REFERENCES tb_post(id),
    PRIMARY KEY (id_user,id_post)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_post_message;
CREATE TABLE tb_post_message(
    id_user int(11) NOT NULL,
    id_post int(11) NOT NULL,
	texto varchar(256) NOT NULL,
    FOREIGN KEY (id_user) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_post) REFERENCES tb_post(id),
    PRIMARY KEY (id_user,id_post)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

/* FIM POSTS */
/* SUBSCRIBE */

 DROP TABLE IF EXISTS tb_follow;
CREATE TABLE tb_follow(
    id_user int(11) NOT NULL,
    id_follow int(11) NOT NULL,
    FOREIGN KEY (id_user) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_follow) REFERENCES tb_usuario(id),
    PRIMARY KEY (id_user,id_follow)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

/* FIM SUBSCRIBE */
/* ACERVOS */

 DROP TABLE IF EXISTS tb_acervo;
CREATE TABLE tb_acervo(
	id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id_owner int(11) NOT NULL,
    nome varchar(30) NOT NULL,
    url varchar(30) DEFAULT NULL,
    UNIQUE KEY (nome),
    FOREIGN KEY (id_owner) REFERENCES tb_usuario(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- ALTER TABLE tb_acervo ADD COLUMN url varchar(30) DEFAULT NULL;

/* FIM ACERVOS */
/* VEÍCULO */

 DROP TABLE IF EXISTS tb_veiculo;
CREATE TABLE tb_veiculo(
	id int(11) unsigned NOT NULL AUTO_INCREMENT,
    id_acervo int(11) NOT NULL,
    nome varchar(50) NOT NULL,
    ano int DEFAULT NULL,
    modelo varchar(50) DEFAULT NULL,    
    marca varchar(50) DEFAULT NULL,    
    combustivel varchar(20) DEFAULT NULL,
    configuracao varchar(15) DEFAULT NULL,
    portas int DEFAULT NULL,    
    lugares int DEFAULT NULL,    
    porte varchar(15) DEFAULT NULL,
	placa varchar(15) DEFAULT NULL,
    procedencia varchar(25) DEFAULT NULL,
    UNIQUE KEY (nome),
    FOREIGN KEY (id_acervo) REFERENCES tb_acervo(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_equipamento;
CREATE TABLE tb_equipamento(
	id int(11) unsigned NOT NULL AUTO_INCREMENT,
    equip varchar(50) NOT NULL,    
    sessao varchar(20) NOT NULL,
    UNIQUE KEY (equip),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_desempenho;
CREATE TABLE tb_vcl_desempenho(
	id_vcl int(11) unsigned NOT NULL,
	ace_0_100 double DEFAULT NULL,
    vel_max double DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_motor;
CREATE TABLE tb_vcl_motor(
	id_vcl int(11) NOT NULL,
    aci_comando varchar(20) DEFAULT NULL,
    alimentacao varchar(20) DEFAULT NULL,
    aspiracao varchar(20) DEFAULT NULL,
    cilindrada int DEFAULT NULL,
    cilindros int DEFAULT NULL,
    cod_motor varchar(20) DEFAULT NULL,
    com_valvula varchar(20) DEFAULT NULL,
    curso_pistao double DEFAULT NULL,
    diam_cilindro double DEFAULT NULL,
    disposicao varchar(20) DEFAULT NULL,
    instalacao varchar(20) DEFAULT NULL,
    peso_pot double DEFAULT NULL,
    peso_tor double DEFAULT NULL,
    pot_esp double DEFAULT NULL,
    pot_max double DEFAULT NULL,
    raz_compressao varchar(20) DEFAULT NULL,
    rpm_max double DEFAULT NULL,
    rpm_pot_max double DEFAULT NULL,
    rpm_torque_max double DEFAULT NULL,
    torque_esp double DEFAULT NULL,
    torque_max double DEFAULT NULL,
    tuchos varchar(20) DEFAULT NULL,
    valvulas int DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_transmissao;
CREATE TABLE tb_vcl_transmissao(
	id_vcl int(11) unsigned NOT NULL,
	acoplamento varchar(20) DEFAULT NULL,
    cambio varchar(20) DEFAULT NULL,
    cod_cambio varchar(20) DEFAULT NULL,
    marchas int DEFAULT NULL,
    tracao varchar(20) DEFAULT NULL,
    reverso boolean DEFAULT 1,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_dimensao;
CREATE TABLE tb_vcl_dimensao(
	id_vcl int(11) unsigned NOT NULL,
	altura double DEFAULT NULL,
	bitola_diant double DEFAULT NULL,
	bitola_tras double DEFAULT NULL,
	carga_vol double DEFAULT NULL,
	carga_peso double DEFAULT NULL,
	comprimento double DEFAULT NULL,
	entre_eixos double DEFAULT NULL,
	largura double DEFAULT NULL,
	peso double DEFAULT NULL,
	tanque double DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_pneus;
CREATE TABLE tb_vcl_pneus(
	id_vcl int(11) unsigned NOT NULL,
	alt_flanco double DEFAULT NULL,
    dianteiro varchar(20) DEFAULT NULL,
    traseiro varchar(20) DEFAULT NULL,
    estepe varchar(20) DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_aerodinamica;
CREATE TABLE tb_vcl_aerodinamica(
	id_vcl int(11) unsigned NOT NULL,
	area_front double DEFAULT NULL,
    area_front_corrig double DEFAULT NULL,
    coef_arrasto double DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_direcao;
CREATE TABLE tb_vcl_direcao(
	id_vcl int(11) unsigned NOT NULL,
	assistencia varchar(20) DEFAULT NULL,
    diam_giro double DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_suspensao;
CREATE TABLE tb_vcl_suspensao(
	id_vcl int(11) unsigned NOT NULL,
	susp_dia varchar(20) DEFAULT NULL,
	susp_tras varchar(20) DEFAULT NULL,
	elem_elast_dia varchar(20) DEFAULT NULL,
	elem_elast_tras varchar(20) DEFAULT NULL,
    curso_susp_diant double DEFAULT NULL,
    curso_susp_tras double DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_freios;
CREATE TABLE tb_vcl_freios(
	id_vcl int(11) unsigned NOT NULL,
	freio_dia varchar(20) DEFAULT NULL,
	freio_tras varchar(20) DEFAULT NULL,
	freio_aciona varchar(20) DEFAULT NULL,
	abs boolean DEFAULT NULL,
	regenerativo boolean DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_consumo;
CREATE TABLE tb_vcl_consumo(
	id_vcl int(11) unsigned NOT NULL,
	autonomia_rod double DEFAULT NULL,
	autonomia_urb double DEFAULT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
    PRIMARY KEY (id_vcl)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE IF EXISTS tb_vcl_equip;
CREATE TABLE tb_vcl_equip(
	id_vcl int(11) unsigned NOT NULL,
	id_equip int(11) unsigned NOT NULL,
	FOREIGN KEY (id_vcl) REFERENCES tb_veiculo(id),
	FOREIGN KEY (id_equip) REFERENCES tb_equipamento(id),
    PRIMARY KEY (id_vcl,id_equip)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;