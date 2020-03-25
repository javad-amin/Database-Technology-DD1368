
<?php

class DB
{
	private $db;
	public function __construct(){
		try {
	    $this->db = new PDO("mysql:host=localhost;dbname=bookingdb;", 'root', 
	    '', array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'UTF8'"));
	    $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	    //return $db;
	    
	    /*** echo a message saying we have connected ***/
	    //echo 'Connected to database.<br />';
		}
		catch(PDOException $e){
		    // For debug purpose, shows all connection details
		    echo 'Connection failed: '.$e->getMessage()."<br />";
		      // Hide connection details.
		    //echo 'Could not connect to database.<br />'); 
		}

	}

	public function Connect () {
		return $this->db;
	}
}
