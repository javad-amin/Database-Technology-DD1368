
<?php
include("init.php");

echo "<h4>Enter the E-mail address you registered your account with</h4>";

if(isset($_POST["sendbutton"]) && isset($_POST["email"]) && !empty($_POST["email"])){
	$db = new DB();
	$dbconn = $db->Connect();

	$email = $_POST['email'];

	try{
		$sql = "SELECT user_email, user_pass FROM users WHERE user_email='$email'"; 
		$stmt = $dbconn->prepare($sql);
		$data = array();
		$stmt -> execute($data);
		$res = $stmt->fetch(PDO::FETCH_ASSOC); 
		$rowCount = $stmt -> rowCount();

		if($rowCount == 1){
			try {    
		        # prepare
		        $sql = "UPDATE users SET user_prts=? 
		          WHERE user_email=? AND user_activated=?";
		        $stmt = $dbconn->prepare($sql);
		        # the data we want to insert
		        $now = new DateTime();
		        $data = array(date('Y-m-d H:i:s', $now->format('U')), $email, 1);
		        # execute width array-parameter
		        $stmt->execute($data);
	    	}
		    catch(PDOException $e){
		    	echo $sql . "<br>" . $e->getMessage();
			}

			echo "<a href='resetpass.php?email=".$email."&hash=".$res['user_pass']."'>Reset password</a>";
		}

		else{
			echo "There is no user with this E-mail. Enter a valid E-mail!";
		}
	}

	catch(PDOException $e){
		echo $sql . "<br>" . $e->getMessage();
	}

}

?>

<form method="post">

<input type="email" name="email" placeholder="E-mail"></input><br><br>

<button type="submit" name="sendbutton">Send reset link</button><br>

</form>

<?php
include("footer.php");
?>
