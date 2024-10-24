<?php

    $query_db = array(

        /* VEÍCULOS */
        "VCL-0" => ' SELECT * FROM vw_veiculos WHERE id_acervo=x00;', // id_acervo
        "VCL-1" => ' SELECT EQP.*, IF(COALESCE(VCL.id_equip,0),1,0) AS tem
                        FROM tb_equipamento AS EQP
                        LEFT JOIN tb_vcl_equip AS VCL
                        ON VCL.id_equip = EQP.id
                        AND VCL.id_vcl = x00;', // id_vcl
        
    );

?>