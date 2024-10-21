<?php
    $conexao = new mysqli("108.167.132.56", "plan3411_consulta", "@Consulta24", "plan3411_vintageclub");
    if (!$conexao){
        die ("Erro de conexão com localhost, o seguinte erro ocorreu -> ".mysql_error());
    }    

?>