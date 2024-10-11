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