<?php

if (IsSet($_POST["cod"]) && IsSet($_POST["params"])){ 

    $cod = $_POST["cod"];
    $params = json_decode($_POST["params"],true); 

//    var_dump($params);

    switch($cod){
        case 1: // File Exist
            if(file_exists($params['filename'])){
                print 1;
            }else{
                print 0;
            }
            break;
        case 2:
            $url = getcwd()."/../".$params['filename'];
            if(file_exists($url)){
                print 1;
            }else{
                print 0;
            }
            break;
    }


}

?>