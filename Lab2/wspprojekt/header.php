<?php
error_reporting(-1); // Report all type of errors
ini_set('display_errors', 1); // Display all errors 
ini_set('output_buffering', 0); // Do not buffer outputs, write directly
?>

<!DOCTYPE html>
<html>
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
<title>PHP Forum</title>
<link rel="stylesheet" href="css\forumstyle.css" type="text/css">
</head>

<body>
	<header>
		<h1 id="centertext">PHP Booking System</h1>
		<?php
		if(isset($_SESSION["currentuserid"]) && $_SESSION["currentuserid"] != null){
			echo "<span>Hello " .$user->getUsername(). "! Not you? <a href='signout.php'>Sign out</a></span>";
		}

		else{
			echo "<span>Hello Guest! Have an account? <a href='login.php'>Sign in</a>. If not register <a href='register.php'>here</a></span>";
		}
		?>
	</header>

	<section>

		<article>
