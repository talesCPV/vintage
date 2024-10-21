<?php   
	if (IsSet($_POST["path"]) && IsSet($_POST["filename"])){
        $path = getcwd().$_POST["path"];
        $ok = 0;
        if (file_exists($path)) {
            $filename = substr($path,0,strlen(end(explode("/",$path))) * -1).$_POST["filename"];
            if (!file_exists($filename)) {
                rename($path,$filename);
                $ok = 1;
            }
        }
        print '{"ok":'.$ok.'}';
    }
?>