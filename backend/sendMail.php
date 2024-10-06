<?php 

    if(isset($_POST['message'])){
        require("libs/PHPMailer.php"); 
        require("libs/SMTP.php"); 
         $mail = new PHPMailer\PHPMailer\PHPMailer(); 
         $mail->IsSMTP(); // enable SMTP 
         $mail->SMTPDebug = 1; // debugging: 1 = errors and messages, 2 = messages only 
         $mail->SMTPAuth = true; // authentication enabled 
         $mail->SMTPSecure = 'ssl'; // secure transfer enabled REQUIRED for Gmail 
         $mail->Host = "mail.planet3.com.br"; 
         $mail->Port = 465; //465 or 587 
         $mail->IsHTML(true); 
         $mail->Username = "vintageclub@planet3.com.br"; 
         $mail->Password = "#Tales77#"; 
//         $mail->SetFrom("tales@planet3.com.br"); 
         $mail->From = 'tales@planet3.com.br';

         $mail->Subject = "Contato pelo Site - Planet3"; 
         $mail->Body = $_POST['message']; 
         $mail->AddAddress("tales@planet3.com.br"); 

        if(!$mail->Send()) { 
            echo "Mailer Error: " . $mail->ErrorInfo; 
        } else { 
            echo "Mensagem enviada com sucesso"; 
        } 
    }


/*
    //Import PHPMailer classes into the global namespace
    //These must be at the top of your script, not inside a function
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;
    
    //Load Composer's autoloader
    require 'vendor/autoload.php';
    
    //Create an instance; passing `true` enables exceptions
    $mail = new PHPMailer(true);
    
    try {
        //Server settings
        $mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
        $mail->isSMTP();                                            //Send using SMTP
        $mail->Host       = 'smtp.example.com';                     //Set the SMTP server to send through
        $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
        $mail->Username   = 'user@example.com';                     //SMTP username
        $mail->Password   = 'secret';                               //SMTP password
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
        $mail->Port       = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`
    
        //Recipients
        $mail->setFrom('from@example.com', 'Mailer');
        $mail->addAddress('joe@example.net', 'Joe User');     //Add a recipient
        $mail->addAddress('ellen@example.com');               //Name is optional
        $mail->addReplyTo('info@example.com', 'Information');
        $mail->addCC('cc@example.com');
        $mail->addBCC('bcc@example.com');
    
        //Attachments
        $mail->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
        $mail->addAttachment('/tmp/image.jpg', 'new.jpg');    //Optional name
    
        //Content
        $mail->isHTML(true);                                  //Set email format to HTML
        $mail->Subject = 'Here is the subject';
        $mail->Body    = 'This is the HTML message body <b>in bold!</b>';
        $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
    
        $mail->send();
        echo 'Message has been sent';
    } catch (Exception $e) {
        echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
    }
*/

?> 