
<?php

class Thread
{
	private $db;
	private $dbconn;
	private $topic_id;
	private $topic_subject;
	private $topic_date;
	private $topic_cat;
	private $topic_by;

	public function __construct(){
		$this->db = new DB('127.0.0.1', 'forumdb', 'root', '' );
		$this->dbconn = $this->db->Connect();
	}

	public function getTopSubj(){
		return $this->topic_subject;
	}

	public function getTopBy(){
		return $this->topic_by;
	}

	public function getTopID(){
		return $this->topic_id;
	}

	public function setTopic($topic_id){
		try{
			$sql = "SELECT * FROM topics WHERE topic_id='$topic_id' " ; 
	    	$stmt = $this->dbconn->prepare($sql);
	    	$data = array();  
	    	$stmt->execute($data);
	    	$res = $stmt->fetch(PDO::FETCH_ASSOC);
	    	$rowCount = $stmt -> rowCount();

	    	if($rowCount == 1){
		    	$this->topic_id = $res['topic_id'];
		    	$this->topic_subject = $res['topic_subject'];
		    	$this->topic_date = $res['topic_date'];
		    	$this->topic_cat = $res['topic_cat'];
		    	$this->topic_by = $res['topic_by'];
	    	}
    	}

    	catch(PDOException $e){
		    echo $sql . "<br />" . $e->getMessage();
		}

	}

	public function showTopic(){

		try{
			$sql = "SELECT user_name FROM users WHERE user_id=".$this->topic_by;
	    	$stmt = $this->dbconn->prepare($sql);
	    	$data = array();  
	    	$stmt->execute($data);
	    	$res = $stmt->fetch(PDO::FETCH_ASSOC);
	    	
    	}

    	catch(PDOException $e){
		    echo $sql . "<br />" . $e->getMessage();
		}
	
		        $output = "<tr>".
		        	"<td id='td'>".htmlentities($res['user_name'])."</td>".
		            "<td id='td'><a href='posts.php?topic_id=".$this->topic_id."'>".htmlentities($this->topic_subject)."</a></td>".
		        "</tr>";	    	
	    	
	    	echo "$output";

	}	
}
