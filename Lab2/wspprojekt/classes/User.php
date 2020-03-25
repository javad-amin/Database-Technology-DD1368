
<?php

class User
{
	protected $user_id;
	protected $user_name;
	protected $user_email;
	protected $user_level;
	protected $user_date;
	protected $dbconn;
	protected $db;

	public function __construct(){
		$this->db = new DB('127.0.0.1', 'bookingdb', 'root', '' );
		$this->dbconn = $this->db->Connect();
		

	}

	public function setAll($user_name){
		$sql = "SELECT * FROM user WHERE user_name='$user_name' " ; 
    	$stmt = $this->dbconn->prepare($sql);
    	$data = array();  
    	$stmt->execute($data);
    	$res = $stmt->fetch(PDO::FETCH_ASSOC);
    	$rowCount = $stmt -> rowCount();

    	if($rowCount == 1){
	    	$this->user_id = $res['user_id'];
	    	$this->user_name = $res['user_name'];
	    	$this->user_email = $res['user_email'];
	    	$this->user_level = $res['user_level'];
	    	$this->user_date = $res['user_date'];
    	}
    	

	}

	public function getUsername(){
		return $this->user_name;
	}

	public function loginCheck($user_name, $user_pass){
		try {
			$sql = "SELECT * FROM user WHERE user_name='$user_name'"; 
			$stmt = $this->dbconn->prepare($sql);
			$data = array();
			$stmt -> execute($data);
			$res = $stmt->fetch(PDO::FETCH_ASSOC); 
			$rowCount = $stmt -> rowCount();

			if($rowCount == 1 && password_verify($user_pass, $res['user_pass']) && $res['user_activated'] == 1){

				$_SESSION["currentusername"] = $res['user_name'];
				$_SESSION["currentuserid"] = $res["user_id"];
				$_SESSION["currentuserlevel"] = $res["user_level"];
                $_SESSION["particUsers"] = array();
                $_SESSION["particPartners"] = array();
				
				header("Location:index.php");
		 	}

		 	else{
		 	echo "Wrong username or password (have you activated your account?)";
		 	}
		}

		catch(PDOException $e){
	    echo $sql . "<br>" . $e->getMessage();
		}
	}

	public function createTopic($topic_subject, $post_content){
		try {
		     # sql
		    $sql = "INSERT INTO topics (topic_subject, topic_cat, topic_by) 
		    VALUES (?, ?, ?)";
		    # prepare
		    $stmt = $this->dbconn->prepare($sql);
		    # the data we want to insert
		    $data = array($topic_subject, $_GET['cat_id'], $this->user_id);
		     # execute width array-parameter
		    $stmt->execute($data);

		    $sql = "SELECT topic_id FROM topics WHERE topic_subject='$topic_subject'";
	    	$stmt = $this->dbconn->prepare($sql);
	    	$data = array();  
	    	$stmt->execute($data);
	    	$res = $stmt->fetch(PDO::FETCH_ASSOC);

		    $sql = "INSERT INTO posts (post_content, post_topic, post_by) 
		    VALUES (?, ?, ?)";
		    # prepare
		    $stmt = $this->dbconn->prepare($sql);
		    # the data we want to insert
		    $data = array($post_content, $res['topic_id'], $this->user_id);
		     # execute width array-parameter
		    $stmt->execute($data);
		    echo "Successfully created a new thread";
		}
		catch(PDOException $e)
		    {
		    echo $sql . "<br>" . $e->getMessage();
		}

	}

	public function createPost($post_content){
		try {
		    # sql
		    $sql = "INSERT INTO posts (post_content, post_topic, post_by) 
		    VALUES (?, ?, ?)";
		    # prepare
		    $stmt = $this->dbconn->prepare($sql);
		    # the data we want to insert
		    $data = array($post_content, $_GET['topic_id'], $this->user_id);
		     # execute width array-parameter
		    $stmt->execute($data);
		    header("Refresh:0");
		}
		catch(PDOException $e)
		    {
		    echo $sql . "<br>" . $e->getMessage();
		}

	}
}

Class Admin extends User
{
	public function createCategory($cat_name, $cat_desc){
		try {
		     # sql
		    $sql = "INSERT INTO categories (cat_name, cat_description) 
		    VALUES (?, ?)";
		    # prepare
		    $stmt = $this->dbconn->prepare($sql);
		    # the data we want to insert
		    $data = array($cat_name, $cat_desc);
		     # execute width array-parameter
		    $stmt->execute($data);
		    echo "Successfully created a new category";
		}
		catch(PDOException $e)
		    {
		    echo $sql . "<br>" . $e->getMessage();
		}

	}

	public function deleteCategory($cat_id){
		try {    
	        # prepare
	        $sql = "DELETE FROM topics WHERE topic_cat=?";
	        $stmt = $this->dbconn->prepare($sql);
	        # the data we want to insert
	        $data = array($cat_id);
	        # execute width array-parameter
	        $stmt->execute($data);

	        $sql = "DELETE FROM categories WHERE cat_id=?";
	        $stmt = $this->dbconn->prepare($sql);
	        # the data we want to insert
	        $data = array($cat_id);
	        # execute width array-parameter
	        $stmt->execute($data);
	            
	        $message = "<br />Record deleted successfully.<br />";
    	}
    	catch(PDOException $e){
        	$message .= $sql . "<br>" . $e->getMessage();
    	}

	}

	public function deleteThread($topic_id){
		try {    
	        # prepare
	        $sql = "DELETE FROM topics WHERE topic_id=?";
	        $stmt = $this->dbconn->prepare($sql);
	        # the data we want to insert
	        $data = array($topic_id);
	        # execute width array-parameter
	        $stmt->execute($data);

	        $sql = "DELETE FROM posts WHERE post_topic=?";
	        $stmt = $this->dbconn->prepare($sql);
	        # the data we want to insert
	        $data = array($topic_id);
	        # execute width array-parameter
	        $stmt->execute($data);
	            
	        $message = "<br />Record deleted successfully.<br />";
    	}
    	catch(PDOException $e){
        	$message .= $sql . "<br>" . $e->getMessage();
    	}

	}

	public function removeUser($user_id){
		try{
			$sql = "SELECT user_level FROM user WHERE user_id=?"; 
			$stmt = $this->dbconn->prepare($sql);
			$data = array($user_id);
			$stmt -> execute($data);
			$res = $stmt->fetch(PDO::FETCH_ASSOC); 
			$rowCount = $stmt -> rowCount();

			if($rowCount == 1 && $res['user_level'] == 0){
				try {    
			        # prepare
			        $sql = "DELETE FROM user WHERE user_id=?";
			        $stmt = $this->dbconn->prepare($sql);
			        # the data we want to insert
			        $data = array($user_id);
			        # execute width array-parameter
			        $stmt->execute($data);
			            
			        $message = "<br />Record deleted successfully.<br />";
    			}
		    	catch(PDOException $e){
		        	echo $sql . "<br>" . $e->getMessage();
		    	}

			}

			else{
				echo "Either the user id does not exist or you are trying to remove an admin... you sneaky bastard...";
			}
		}

		catch(PDOException $e){
			echo $sql . "<br>" . $e->getMessage();
		}

	}
}


