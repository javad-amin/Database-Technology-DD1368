
<?php
include("init.php");

echo "<h4>Enter new password</h4>";

if(isset($_GET['email']) && !empty($_GET['email']) && isset($_GET['hash']) && !empty($_GET['hash'])){

	if(isset($_POST["sendbutton"]) && isset($_POST["pass"]) && !empty($_POST["pass"]) && isset($_POST["passagain"]) && !empty($_POST["passagain"]) && $_POST["pass"] === $_POST["passagain"]){
		$db = new DB();
		$dbconn = $db->Connect();

		$email = htmlspecialchars($_GET['email']);
		$hash = htmlspecialchars($_GET['hash']);
		$newpass = htmlspecialchars($_POST['pass']);

		try{
			$sql = "SELECT user_email, user_pass, user_prts FROM users WHERE user_email='$email' AND user_pass='$hash'"; 
			$stmt = $dbconn->prepare($sql);
			$data = array();
			$stmt -> execute($data);
			$res = $stmt->fetch(PDO::FETCH_ASSOC); 
			$rowCount = $stmt -> rowCount();

			$prts = new DateTime($res['user_prts']);
			$now = new DateTime();
			$timelimitsec = 15*60;
			$diffsec = $now->format('U') - $prts->format('U');

			if($rowCount == 1 && $timelimitsec > $diffsec){
				try {    
			        # prepare
			        $sql = "UPDATE users SET user_pass=? 
			          WHERE user_email=? AND user_pass=? AND user_activated=?";
			        $stmt = $dbconn->prepare($sql);
			        # the data we want to insert
			        $data = array(password_hash($newpass, PASSWORD_DEFAULT), $email, $hash, 1);
			        # execute width array-parameter
			        $stmt->execute($data);
			            
			        $message = "<br />Your password is successfully changed! You can now log in with your new password.<br />";
			        echo $message;
	    		}
			    catch(PDOException $e){
			    	echo $sql . "<br>" . $e->getMessage();
				}
			}

			else{
				echo "The URL is invalid or the time limit for a password reset has passed";
			}
		}

		catch(PDOException $e){
			echo $sql . "<br>" . $e->getMessage();
		}

	}

}

else{
	echo "URL is invalid";
}
?>

<form method="post">

<input type="pass" name="pass" placeholder="New password"></input><br>
<input type="pass" name="passagain" placeholder="Enter new password again"></input><br><br>

<button type="submit" name="sendbutton">Change password</button><br>

</form>

<?php
include("footer.php");
?>
