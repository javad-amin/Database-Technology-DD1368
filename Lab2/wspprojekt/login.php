
<?php
include("init.php");

if(isset($_POST["loginbutton"]) && !empty($_POST["username"]) && !empty($_POST["password"])){
$user = new User();
$user->loginCheck($_POST['username'], $_POST['password']);




}

?>

<form method="post">

<input type="text" name="username" placeholder="Username"></input><br>
<input type="password" name="password" placeholder="Password"></input><br><br>

<button type="submit" name="loginbutton">Login</button><br>
<a href="register.php">Don't have an account? Register here!</a><br>
<a href="forgotpass.php">Forgot your password?</a>

</form>

<?php
include("footer.php");
?>
