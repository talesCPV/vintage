<?php

    $query_db = array(
        /* LOGIN */
        "LOG-0"  => 'CALL sp_login("x00", "x01");', // USER, PASS

        /* USERS */
        "USR-0"  => 'CALL sp_viewUser(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE
        "USR-1"  => 'CALL sp_setUser(@access,@hash,x00,"x01","x02","x03",x04);', // ID, NOME, EMAIL, PASS, ACCESS
        "USR-2"  => 'CALL sp_updateUser(@hash,"x00","x01");', // NOME, PASS
        "USR-3"  => 'CALL sp_check_usr_mail(@hash);',
        "USR-4"  => 'CALL sp_newUser("x00","x01","x02","x03");', // NOME, SOBRENOME, EMAIL,SENHA
        "USR-5"  => 'CALL sp_authUser("x00");', // EMAIL

        /* CALENDAR */
        "CAL-0"  => 'CALL sp_view_calendar(@hash,"x00","x01");', // DT_INI, DT_FIN
        "CAL-1"  => 'CALL sp_set_calendar(@hash,"x00","x01");', // DT_AGD, OBS

        /* MAIL */
        "MAIL-0"  => 'CALL sp_set_mail(@hash,"x00","x01");', // ID_TO, MESSAGE
        "MAIL-1"  => 'CALL sp_view_mail(@hash,x00);', // I_SEND
        "MAIL-2"  => 'CALL sp_all_mail_adress(@hash);', //      
        "MAIL-3"  => 'CALL sp_del_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO
        "MAIL-4"  => 'CALL sp_mark_mail(@hash,"x00",x01,x02);', // DATA, ID_FROM, ID_TO

        /* SYSTEMA */
        "SYS-0"  => 'CALL sp_set_usr_perm_perf(@access,@hash,x00,"x01");', // ID, NOME
        "SYS-1"  => 'CALL sp_view_usr_perm_perf(@access,@hash,"x00","x01","x02");', // FIELD,SIGNAL, VALUE

        /*AGENDA*/
        "AGD-0" => 'CALL sp_view_agenda(@hash);',
        "AGD-1" => 'CALL sp_set_agenda(@access,@hash,x00,x01,x02,x03,x04);', // id_aluno, id_aula, dia, hora, del
        "AGD-2" => 'CALL sp_view_agenda_dia(@hash);',
        "AGD-3" => 'CALL sp_set_aula_dada(@access,@hash,x00,x01,"x02","x03",x04,x05);', // id_aluno,id_aula,data_hora,valor,pg,del
        "AGD-4" => 'CALL sp_view_aula_dada(@access,@hash,"x00","x01");',

        /* CONFIGURAÇÔES */
        "CONF-0" => 'CALL sp_view_equip(@access,@hash,"x00","x01");', // EQUIP,SESSAO
        "CONF-1" => 'CALL sp_set_equip(@access,@hash,x00,"x01","x02");', // ID,EQUIP,SESSAO

        /* POST */
        
        "PST-0" => 'CALL sp_view_post(@access,@hash,"x00",x01,x02);', // DATA,ID_START, ID_END
        "PST-1" => 'CALL sp_set_post(@access,@hash,x00,"x01");', // ID, TEXTO

        /* ACERVO */
        "ACV-0" => 'CALL sp_view_acervo(@access,@hash,"x00");', // NOME
        "ACV-1" => 'CALL sp_set_acervo(@access,@hash,x00,x01,"x02");', // ID,ID_OWNER,NOME

        /* VEÍCULOS */
        "VCL-0"  => 'CALL sp_view_veiculo(@access,@hash,x00,"x01","x02","x03");', // ID_ACERVO, FIELD, SIGNAL, VALUE
        "VCL-1"  => 'CALL sp_new_veiculo(@access,@hash,x00,"x01");', // id_acervo,nome
        "VCL-2"  => 'CALL sp_set_veiculo(@access,@hash,x00,x01,"x02","x03","x04","x05","x06","x07",x08,x09,"x10","x11","x12");', //id,id_acervo,nome,ano,modelo,marca,combustivel,configuracao,portas,lugares,porte,placa,procedencia
        "VCL-3"  => 'CALL sp_set_vcl_desempenho(@access,@hash,x00,"x01","x02");', // id_vcl,ace_0_100,vel_max
        "VCL-4"  => 'CALL sp_set_vcl_motor(@access,@hash,x00,"x01","x02","x03","x04","x05","x06","x07","x08","x09","x10","x11","x12","x13","x14","x15","x16","x17","x18","x19","x20","x21","x22","x23");', // id_vcl,aci_comando,alimentacao,aspiracao,cilindrada,cilindros,cod_motor,com_valvula,curso_pistao,diam_cilindro,disposicao,instalacao,peso_pot,peso_tor,pot_esp,pot_max,raz_compressao,rpm_max,rpm_pot_max,rpm_torque_max,torque_esp,torque_max,tuchos,valv_cilindros
        "VCL-5"  => 'CALL sp_set_vcl_transmissao(@access,@hash,x00,"x01","x02","x03","x04","x05");', // id_vcl,acoplamento,cambio,cod_cambio,marchas,tracao
        "VCL-6"  => 'CALL sp_set_vcl_dimensao(@access,@hash,x00,"x01","x02","x03","x04","x05","x06","x07","x08","x09","x10");', // id_vcl,altura,bitola_diant,bitola_tras,carga_vol,carga_peso,comprimento,entre_eixos,largura,peso,tanque
        "VCL-7"  => 'CALL sp_set_vcl_pneu(@access,@hash,x00,"x01","x02","x03","x04");', // id_vcl,alt_flanco,dianteiro,traseiro,estepe
        "VCL-8"  => 'CALL sp_set_vcl_aero(@access,@hash,x00,"x01","x02","x03");', // id_vcl,area_front,area_front_corrig,coef_arrasto
        "VCL-9"  => 'CALL sp_set_vcl_direcao(@access,@hash,x00,"x01","x02");', // id_vcl,assistencia,diam_giro
        "VCL-10" => 'CALL sp_set_vcl_susp(@access,@hash,x00,"x01","x02","x03","x04","x05","x06");', // id_vcl,susp_dia,susp_tras,elem_elast_dia,elem_elast_tras,curso_susp_diant,curso_susp_tras
        "VCL-11" => 'CALL sp_set_vcl_freio(@access,@hash,x00,"x01","x02","x03","x04","x05");', // id_vcl,freio_dia,freio_tras,freio_aciona,abs,regenerativo
        
    );

?>