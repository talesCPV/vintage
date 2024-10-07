<?php 
/*
    if(isset($_POST['subject']) && isset($_POST['message'])){
        require("libs/PHPMailer.php"); 
        require("libs/SMTP.php"); 
//         $mail = new PHPMailer\PHPMailer\PHPMailer(); 
         $mail = new PHPMailer(true);          
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
         $mail->From = 'vintageclub@planet3.com.br';

         $mail->Subject = $_POST['subject']; 
         $mail->Body = $_POST['message']; 
         $mail->AddAddress("tales@planet3.com.br"); 

        if(!$mail->Send()) { 
            echo "Mailer Error: " . $mail->ErrorInfo; 
        } else { 
            echo "Mensagem enviada com sucesso"; 
        } 
    }
*/



    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;

    if(isset($_POST['subject']) && isset($_POST['message']) && isset($_POST['email'])){       

        require 'PHPMailer/src/Exception.php';
        require 'PHPMailer/src/PHPMailer.php';
        require 'PHPMailer/src/SMTP.php';

        $mail = new PHPMailer(true);
        
        try {
//Server settings
    //        $mail->SMTPDebug = SMTP::DEBUG_SERVER;    
            $mail->SMTPDebug = 0;  // debugging: 1 = errors and messages, 2 = messages only 
            $mail->isSMTP();                                            //Send using SMTP
            $mail->Host       = 'mail.planet3.com.br';                  //Set the SMTP server to send through
            $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
            $mail->Username   = 'vintageclub@planet3.com.br';           //SMTP username
            $mail->Password   = '#Tales77#';                            //SMTP password
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
            $mail->Port       = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`
        
//Recipients
            $mail->setFrom('vintageclub@planet3.com.br', 'Vintage Club');
            $mail->addAddress($_POST['email']);
    //        $mail->addAddress('ellen@example.com');
    //        $mail->addReplyTo('info@example.com', 'Information');
    //        $mail->addCC('cc@example.com');
    //        $mail->addBCC('bcc@example.com');
        
//Attachments
    //        $mail->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
    //        $mail->addAttachment('/tmp/image.jpg', 'new.jpg');    //Optional name
        
//Content
            $mail->isHTML(true);                                  //Set email format to HTML
            $mail->Subject = $_POST['subject'];
            $mail->Body    = $_POST['message'];
    //        $mail->AltBody = 'This is the body in plain text for non-HTML mail clients'; 

            $mail->send();
            echo 'Message has been sent';
        } catch (Exception $e) {
            echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
        }

    }
?> 