
<?php
include("init.php");
include("functions\checkiflogged.php");

/*if(!isset($_SESSION["currentuserlevel"])){
	$url="Location:threads.php?cat_id=".$_GET['cat_id'];
	header("$url");
	
}*/

if(isset($_POST["createtopicbutton"])){
	$user->createTopic($_POST["topicsubject"], $_POST["threadpost"]);
}

?>

<form method="post">

<input type="text" name="topicsubject" placeholder="Topic subject"></input><br><br>
<textarea placeholder="Post your thoughts..." name="threadpost" cols="50" rows="5"></textarea><br><br>
<button type="submit" name="createtopicbutton">Create Thread</button><br>

</form>

<?php
include("footer.php");
?>
