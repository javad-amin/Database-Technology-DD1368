
<?php

class Category
{
	private $db;
	private $dbconn;
	private $cat_id;
	private $cat_name;
	private $cat_description;

	public function __construct(){
		$this->db = new DB('127.0.0.1', 'forumdb', 'root', '' );
		$this->dbconn = $this->db->Connect();
	}

	public function getCatName(){
		return $this->cat_name;
	}

	public function getCatDesc(){
		return $this->cat_description;
	}

	public function getCatID(){
		return $this->cat_id;
	}

	public function setCategory($cat_id){
		try{
			$sql = "SELECT * FROM categories WHERE cat_id='$cat_id' " ; 
	    	$stmt = $this->dbconn->prepare($sql);
	    	$data = array();  
	    	$stmt->execute($data);
	    	$res = $stmt->fetch(PDO::FETCH_ASSOC);
	    	$rowCount = $stmt -> rowCount();

	    	if($rowCount == 1){
		    	$this->cat_id = $res['cat_id'];
		    	$this->cat_name = $res['cat_name'];
		    	$this->cat_description = $res['cat_description'];
	    	}
    	}

    	catch(PDOException $e){
		    echo $sql . "<br />" . $e->getMessage();
		}

	}

	public function showCategory(){
	
		        $output = "<tr>".
		            "<td id='td'><a href='threads.php?cat_id=".$this->getCatID()."'>".htmlentities($this->cat_name)."</a></td>".
		            "<td id='td'>".htmlentities($this->cat_description)."</td>".
		        "</tr>";	    	
	    	
	    	echo "$output";

	}
}
