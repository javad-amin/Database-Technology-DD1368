

<?php
include("init.php");


$posts = [];
$i = -1;

echo "<h2>Post</h2>";

try {
	$db = new DB();
	$dbconn = $db->Connect();
	 /*** The SQL SELECT statement ***/
	$sql = "SELECT post_id FROM posts WHERE post_topic=".$_GET['topic_id'];
	$stmt = $dbconn->prepare($sql);
		 
	// fetch width column names, create a table
	$data = array();  
	$stmt->execute($data);
	echo "<table><tr><th>User</th><th id='thsetwidth'>Content</th></tr>";
	while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$i++;
		$posts[$i] = new Post();
		$posts[$i]->setPost($res['post_id']);
		$posts[$i]->showPost();
	}
	echo "</table>";   	
}
		
catch(PDOException $e){
	echo $sql . "<br />" . $e->getMessage();
}

if(isset($_POST["createpostbutton"])){
	$user->createPost($_POST["replycontent"]);
}

if(isset($_SESSION["currentuserid"])){
    echo "<br>
	<form method='post'>

	<textarea placeholder='Post your thoughts...'' name='replycontent' cols='50' rows='5'></textarea><br><br>
	<button type='submit' name='createpostbutton'>Reply</button><br>

	</form>";
}

?>


<?php
include("footer.php");
?>
