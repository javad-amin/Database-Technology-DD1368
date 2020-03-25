
<?php
include("init.php");

if(isset($_POST["registerbutton"]) && !empty($_POST["username"]) && !empty($_POST["password"]) && !empty($_POST["email"])){
	$db = new DB();
	$dbconn = $db->Connect();

	$username = $_POST["username"];
	$email = $_POST["email"];
	$password = $_POST["password"];
    $teamid = $_POST["teamSelect"];
    $position = $_POST["positionSelect"];
    $fullname = $_POST["fullname"];

	$sql = "SELECT * FROM user WHERE user_name='$username' OR user_email='$email' " ; 
	$stmt = $dbconn->prepare($sql);
	$data = array();
	$stmt -> execute($data); 
	$rowCount = $stmt -> rowCount();

	if($rowCount == 0){
		try {
		    # sql
		    $sql = "INSERT INTO user (user_name, user_fullname, user_pass, user_email, position_id, team_id) 
		    VALUES (?, ?, ?, ?, ?, ?)";
		    # prepare
		    $stmt = $dbconn->prepare($sql);
		    # the data we want to insert
		    $hash = password_hash($password, PASSWORD_DEFAULT);
		    $data = array($username, $fullname, $hash, $email, $position, $teamid);
		     # execute width array-parameter
		    $stmt->execute($data);
		    
		    //echo "Success!";

		    $message = "Thank you for signing up! To be able to login to our forum you must 
		    first activate your acccount by clicking this link: <a href='verify.php?email=".$email."&hash=".$hash."'>Activate Account</a>" ;
		    echo $message;
		    //mail($email, 'Account activation link', $message, 'From: doNotReply@phpforum.com');
		}

			catch(PDOException $e){
		    echo $sql . "<br>" . $e->getMessage();
			}
	}

		else{
			echo "Username or E-mail already exists";
		}

}

$db = new DB();
$dbconn = $db->Connect();

$sql = "SELECT position_id, position FROM position";
$stmt = $dbconn->prepare($sql);
$stmt->execute();
$posData = $stmt->fetchAll(PDO::FETCH_ASSOC);

$sql = "SELECT team_id, name FROM team";
$stmt = $dbconn->prepare($sql);
$stmt->execute();
$teamData = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>
<form method="post">

<input type="text" name="username" placeholder="Username"></input><br>
<input type="text" name="fullname" placeholder="Full name"></input><br>
<input type="email" name="email" placeholder="E-mail"></input><br>
<input type="password" name="password" placeholder="Password"></input><br><br>

Position:<br>
<select name="positionSelect">
 <?php foreach ($posData as $row): ?>
    <option value="<?php echo $row["position_id"]; ?>"><?=$row["position"]?></option>
<?php endforeach ?>
</select>
<br><br>

Team:<br>
<select name="teamSelect">
 <?php foreach ($teamData as $row): ?>
    <option value="<?php echo $row["team_id"]; ?>"><?=$row["name"]?></option>
<?php endforeach ?>
</select>
<br><br>

<button type="submit" name="registerbutton" >Register</button><br>
<a href="login.php">Login</a>

</form>

<?php
include("footer.php");
?>