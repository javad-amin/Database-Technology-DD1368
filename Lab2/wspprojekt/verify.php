
<?php
include("init.php");

if(isset($_GET['email']) && !empty($_GET['email']) && isset($_GET['hash']) && !empty($_GET['hash'])){
	$db = new DB();
	$dbconn = $db->Connect();

	$email = $_GET['email'];
	$hash = $_GET['hash'];

	try {
		$sql = "SELECT user_email, user_pass, user_activated, user_date FROM user WHERE user_email='$email' AND user_pass='$hash' AND user_activated ='0'"; 
		$stmt = $dbconn->prepare($sql);
		$data = array();
		$stmt -> execute($data);
		$res = $stmt->fetch(PDO::FETCH_ASSOC); 
		$rowCount = $stmt -> rowCount();
		
		$regdate = new DateTime($res['user_date']);
		$now = new DateTime();
		$timelimitsec = 15*60;
		$diffsec = $now->format('U') - $regdate->format('U');

		if($rowCount > 0 && $timelimitsec > $diffsec){
			try {    
		        # prepare
		        $sql = "UPDATE user SET user_activated=? 
		          WHERE user_email=? AND user_pass=? AND user_activated=?";
		        $stmt = $dbconn->prepare($sql);
		        # the data we want to insert
		        $data = array(1, $email, $hash, 0);
		        # execute width array-parameter
		        $stmt->execute($data);
		            
		        $message = "<br />Your account has been successfully actived! You can now log in.<br />";
		        echo $message;
	    	}
		    catch(PDOException $e){
		    	echo $sql . "<br>" . $e->getMessage();
			}
		}

		else{
			echo "The url is invalid, you have already activated your account or the time limit for activation has passed";
		}

	}

	catch(PDOException $e){
		echo $sql . "<br>" . $e->getMessage();
	}

	
	
}
?>




<?php
include("footer.php");
?>