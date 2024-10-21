<?php

    if (IsSet($_POST["cod"]) && IsSet($_POST["params"])){

        include_once "connect.php";
        include_once "crip.php";

        $cod = $_POST["cod"];
        $params = json_decode($_POST["params"],true);
        $rows = array();

        include_once "sql.php";

        $query = $query_db[$_POST["cod"]];

        $i = 0;
        foreach($params as $key => $val ){
            $y = 'y'.str_pad(strval($i), 2, "0", STR_PAD_LEFT);
            $x = 'x'.str_pad(strval($i), 2, "0", STR_PAD_LEFT);

            $query = str_replace($y, $key,$query); // fields
            $query = str_replace($x, $val,$query); // values
            $i++;
        }

//    echo $query; 

            $result = mysqli_query($conexao, $query);
            if(is_object($result)){
                if($result->num_rows > 0){			
                    while($r = mysqli_fetch_assoc($result)) {
                        $rows[] = $r;
                    }
                }        
            }

	    $conexao->close();        

        print json_encode($rows);
    }

?>