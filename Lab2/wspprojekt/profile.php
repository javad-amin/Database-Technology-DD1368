

<?php
include("init.php");

$user_id = $_GET['user_id'];


if(isset($_POST["cancMeetingButton"])){
    $db = new DB();
	$dbconn = $db->Connect();
    
    $meetingid = $_POST["meetingSelect"];


   	try {
		$sql = "DELETE FROM participant WHERE meeting_id=?";
		$stmt = $dbconn->prepare($sql);
		$data = array($meetingid);
		$stmt->execute($data);
		
		$sql = "DELETE FROM meeting WHERE meeting_id=?";
		$stmt = $dbconn->prepare($sql);
		$data = array($meetingid);
		$stmt->execute($data);
		
		$sql = "DELETE FROM team_totalcost_log WHERE meeting_id=?";
		$stmt = $dbconn->prepare($sql);
		$data = array($meetingid);
		$stmt->execute($data);
		echo "Meeting was successfully cancelled!<br><br>";
	}

    catch(PDOException $e){
      echo $sql . "<br>" . $e->getMessage();
    }
    
}

$db = new DB();
$dbconn = $db->Connect();
try{
    $sql = "SELECT user_name, user_id, user_fullname FROM user WHERE user_id='$user_id'"; 
    $stmt = $dbconn->prepare($sql);
    $data = array();
    $stmt -> execute($data);
    $res = $stmt->fetch(PDO::FETCH_ASSOC); 
    $rowCount = $stmt -> rowCount();

    if($rowCount == 1){
      $user_name = $res['user_name'];
      $userprofileid = $res['user_id'];
      $fullname = $res['user_fullname'];

      echo "<p>Username: $user_name</p>
            <p>User ID: $userprofileid</p>
            <p>Full name: $fullname</p>";
    }

    else{
      echo "Invalid URL";
    }
}

catch(PDOException $e){
    echo $sql . "<br>" . $e->getMessage();
}

try{
    $datenow = date("Y-m-d H:i:s");
    $sql = "SELECT meeting_id, start_time, end_time 
            FROM meeting
            WHERE user_id='$user_id'
            AND start_time > '$datenow'"; 
    $stmt = $dbconn->prepare($sql);
    $stmt->execute();
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
}

catch(PDOException $e){
    echo $sql . "<br>" . $e->getMessage();
}

if(isset($_POST["showParticipants"])) {
    $db = new DB();
	$dbconn = $db->Connect();
    
	$meetingid = $_POST["meetingSelect"];
	try {
        # sql
        $sql = "SELECT user.user_name, business_partner.name
                FROM ((participant
                LEFT JOIN user ON participant.user_id = user.user_id)
                LEFT JOIN business_partner ON participant.partner_id = business_partner.partner_id)
                WHERE participant.meeting_id = '$meetingid'";
               
        $stmt = $dbconn->prepare($sql);
        $data = array();
        $stmt->execute($data);
        echo "Meeting participants:<br><br>";
        while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
            if($res["user_name"]){
                echo $res["user_name"]."<br>";
            }
            else{
                echo $res["name"]."<br>";
            }
        }
        echo "<br>";
    }

    catch(PDOException $e){
      echo $sql . "<br>" . $e->getMessage();
    }
}


if(isset($_SESSION['currentuserid']) && $_SESSION['currentuserid'] === $user_id){
?>

<form method="post">
<h4>Cancel meeting</h4>
<select name="meetingSelect">
<?php foreach ($data as $row): ?>
    <option value="<?php echo $row["meeting_id"]; ?>"><?php echo $row['meeting_id'].": ".$row['start_time']." - ".$row['end_time']?></option>
<?php endforeach ?>
</select>
<br><br>
<button type="submit" name="cancMeetingButton" >Cancel meeting</button>
<button type="submit" name="showParticipants" >Show meeting participants</button>

</form>

<?php
}
?>


<?php
include("footer.php");
?>
