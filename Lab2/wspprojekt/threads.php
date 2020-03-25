

<?php
include("init.php");


$topics = [];
$i = -1;

echo "<h2>Threads</h2>";
if(isset($_SESSION['currentuserid'])){
	echo "<a href='createthread.php?cat_id=".$_GET['cat_id']."'>Create new thread</a>";
}

try {
	$db = new DB();
	$dbconn = $db->Connect();
	 /*** The SQL SELECT statement ***/
	$sql = "SELECT topic_id FROM topics WHERE topic_cat=".$_GET['cat_id'];
	$stmt = $dbconn->prepare($sql);
		 
	// fetch width column names, create a table
	$data = array();  
	$stmt->execute($data);
	echo "<table><tr><th>By</th><th id='thsetwidth'>Subject</th></tr>";
	while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$i++;
		$topics[$i] = new Thread();
		$topics[$i]->setTopic($res['topic_id']);
		$topics[$i]->showTopic();
	}
	echo "</table>";   	
}
		
		catch(PDOException $e)
		{
		    echo $sql . "<br />" . $e->getMessage();
		}



?>


<?php
include("footer.php");
?>
