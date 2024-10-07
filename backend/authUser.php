<?php

    if(isset($_GET['email'])){
        include_once "connect.php";

        $query = 'CALL sp_authUser("'.$_GET['email'].'");';

        $result = mysqli_query($conexao, $query);
        if(is_object($result)){
            if($result->num_rows > 0){			
                while($r = mysqli_fetch_assoc($result)) {
                    $rows[] = $r;
                }
            }        
        }
        if($rows[0]['auth'] == '1'){
            header("Location: https://localhost/vintage/", true, 302); exit;
        }else{
            header("Location: https://www.google.com", true, 302); exit;
        }
        echo $rows[0]->auth;

        $conexao->close();        

        print json_encode($rows);

    }else{
        header("Location: https://www.google.com", true, 302); exit;
    }

//    

?>