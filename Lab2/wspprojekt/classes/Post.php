
<?php

class Post
{
	private $db;
	private $dbconn;
	private $post_id;
	private $post_content;
	private $post_date;
	private $post_topic;
	private $post_by;

	public function __construct(){
		$this->db = new DB('127.0.0.1', 'forumdb', 'root', '' );
		$this->dbconn = $this->db->Connect();
	}

	public function getPostContent(){
		return $this->post_content;
	}

	public function getPostBy(){
		return $this->post_by;
	}

	public function getPostID(){
		return $this->post_id;
	}

	public function setPost($post_id){
		try{
			$sql = "SELECT * FROM posts WHERE post_id='$post_id' " ; 
	    	$stmt = $this->dbconn->prepare($sql);
	    	$data = array();  
	    	$stmt->execute($data);
	    	$res = $stmt->fetch(PDO::FETCH_ASSOC);
	    	$rowCount = $stmt -> rowCount();

	    	if($rowCount == 1){
		    	$this->post_id = $res['post_id'];
		    	$this->post_content = $res['post_content'];
		    	$this->post_date = $res['post_date'];
		    	$this->post_topic = $res['post_topic'];
		    	$this->post_by = $res['post_by'];
	    	}
    	}

    	catch(PDOException $e){
		    echo $sql . "<br />" . $e->getMessage();
		}

	}

	public function showPost(){

		try{
			$sql = "SELECT user_name, user_avatar FROM users WHERE user_id=".$this->post_by;
	    	$stmt = $this->dbconn->prepare($sql);
	    	$data = array();  
	    	$stmt->execute($data);
	    	$res = $stmt->fetch(PDO::FETCH_ASSOC);
	    	
    	}

    	catch(PDOException $e){
		    echo $sql . "<br />" . $e->getMessage();
		}
				$user_avatar = $res['user_avatar'];
		        $output = "<tr>".
		            "<td id='td'><a href='profile.php?user_id=".$this->post_by."'>".htmlentities($res['user_name'])."</a><br><br><img src='avatars/$user_avatar' alt='User avatar' style='width:80px;height:80px;''></td>".
		            "<td id='td'>".htmlentities($this->post_content)."</td>".
		        "</tr>";	    	
	    	
	    	echo "$output";

	}	
}