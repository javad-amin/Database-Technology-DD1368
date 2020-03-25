

<?php
include("init.php");
include("functions\checkiflogged.php");

echo "<h2>Book meeting</h2>";

$userid = $_SESSION["currentuserid"];
$username = $_SESSION["currentusername"];

if(isset($_POST["bookbutton"])){
    $db = new DB();
	$dbconn = $db->Connect();
    
    $roomid = $_POST["roomSelect"];
    $starttime = str_replace("T"," ",$_POST["starttime"]).":00";
    $endtime = str_replace("T"," ",$_POST["endtime"]).":00";
    $diffInMin = (strtotime($endtime) - strtotime($starttime))/60;
    $cost = $diffInMin*0.5;
    
    // Add costs of facilities
    $sql = "
    SELECT 
    facility.facility_cost 
    FROM facility_in
    INNER JOIN facility 
    ON facility_in.facility_id = facility.facility_id 
    WHERE facility_in.room_id=?";
    $stmt = $dbconn->prepare($sql);
    $data = array($roomid);  
    $stmt->execute($data);
    while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
		$cost += $res['facility_cost'];
	}
	
	$sql = "SELECT room_id
            FROM meeting
            WHERE room_id = '$roomid'
            AND 
            (('$starttime' <= start_time AND '$endtime' <= end_time AND '$endtime' >= start_time)
            OR ('$starttime' >= start_time AND '$starttime' <= end_time AND '$endtime' >= end_time)
            OR ('$starttime' <= start_time AND '$endtime' >= end_time)
            OR ('$starttime' >= start_time AND '$endtime' <= end_time))";
	$stmt = $dbconn->prepare($sql);
	$data = array();  
	$stmt->execute($data);
	$rowCount = $stmt->rowCount();
	
	if($rowCount > 0){
		echo "The room is already booked at this time!<br><br>";
	}
    
	else{
		if($diffInMin > 0 && date("Y-m-d H:i:s") < $starttime){
			try {
            // Book meeting
			# sql
			$sql = "INSERT INTO meeting (user_id, room_id, start_time, end_time, booking_cost) 
			VALUES (?,?,?,?,?)";
			# prepare
			$stmt = $dbconn->prepare($sql);
			# the data we want to insert
			$data = array($userid, $roomid, $starttime, $endtime, $cost);
			 # execute width array-parameter
			$stmt->execute($data);
            $meetingid = $dbconn->lastInsertId();
            
            // Finds team and add to cost to team log
            $sql = "SELECT T.team_id, T.name
                    FROM user as U
                    INNER JOIN team as T ON T.team_id = U.team_id
                    WHERE U.user_id = '$userid'";
            $stmt = $dbconn->prepare($sql);
            $data = array();  
            $stmt->execute($data);
            $res = $stmt->fetch(PDO::FETCH_ASSOC);
            $teamid = $res["team_id"];
            $teamname = $res["name"];
            
            // Insert into team log
            $sql = "INSERT INTO team_totalcost_log (team_id, meeting_id, cost, name, start_time)
                    VALUES (?,?,?,?,?)";
			$stmt = $dbconn->prepare($sql);
			$data = array($teamid, $meetingid, $cost, $teamname, $starttime);
			$stmt->execute($data);
			
            // Insert user participants
			foreach ($_SESSION["particUsers"] as $value) {
                $sql = "INSERT INTO participant (meeting_id, user_id, partner_id)
                    VALUES (?,?,?)";
                $stmt = $dbconn->prepare($sql);
                $data = array($meetingid, $value, NULL);
                $stmt->execute($data);
            }
            // Insert partner participants
            foreach ($_SESSION["particPartners"] as $value) {
                $sql = "INSERT INTO participant (meeting_id, user_id, partner_id)
                    VALUES (?,?,?)";
                $stmt = $dbconn->prepare($sql);
                $data = array($meetingid, NULL, $value);
                $stmt->execute($data);
            }
            // Insert current user as participant
            $sql = "INSERT INTO participant (meeting_id, user_id, partner_id)
                    VALUES (?,?,?)";
            $stmt = $dbconn->prepare($sql);
            $data = array($meetingid, $userid, NULL);
            $stmt->execute($data);
            // Clear participants arrays
			$_SESSION["particUsers"] = array();
            $_SESSION["particPartners"] = array();
            
            $message = "Meeting successfully booked!<br><br>";
			echo $message;
			}
            
			catch(PDOException $e){
			echo $sql . "<br>" . $e->getMessage();
			}
		}
		else{
			echo "End time must be greater than start time!<br><br>";
		}
    }
}

if(isset($_POST["showRoomByTime"])){
    $db = new DB();
	$dbconn = $db->Connect();
    
	
	$startTimeHtml = $_POST["starttime"];
	$endTimeHtml = $_POST["endtime"];
    $starttime = str_replace("T"," ",$_POST["starttime"]).":00";
    $endtime = str_replace("T"," ",$_POST["endtime"]).":00";
    
    try{
        $sql = "
            SELECT room_id
            FROM room
            WHERE room_id NOT IN
            (SELECT room_id
            FROM meeting
            WHERE
            ('$starttime' <= start_time AND '$endtime' <= end_time AND '$endtime' >= start_time)
            OR ('$starttime' >= start_time AND '$starttime' <= end_time AND '$endtime' >= end_time)
            OR ('$starttime' <= start_time AND '$endtime' >= end_time)
            OR ('$starttime' >= start_time AND '$endtime' <= end_time))";
        $stmt = $dbconn->prepare($sql);
        $data = array();  
        $stmt->execute($data);
        echo "Available rooms during chosen time slot:<br><br>";
        while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo $res["room_id"] . "<br>";
        }
        echo "<br>";
    }
    
    catch(PDOException $e){
        echo $sql . "<br>" . $e->getMessage();
    }
    
}


if(isset($_POST["showFacilities"])){
    $db = new DB();
	$dbconn = $db->Connect();
    
    $roomid = $_POST["roomSelect"];
   try {
        # sql
        $sql = "SELECT B.name
                FROM facility_in as A
                INNER JOIN facility as B ON A.facility_id = B.facility_id
                WHERE A.room_id = '$roomid'";
        # prepare
        $stmt = $dbconn->prepare($sql);
        # the data we want to insert
        $data = array();
         # execute width array-parameter
        $stmt->execute($data);
        echo "Available facilities in selected room:<br><br>";
        while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo $res["name"] . "<br>";
        }
        echo "<br>";
    }

    catch(PDOException $e){
      echo $sql . "<br>" . $e->getMessage();
    }
    
}


if(isset($_POST["roomOccupButton"])){
    $db = new DB();
	$dbconn = $db->Connect();
    
    $roomid = $_POST["roomSelect"];
    $date = $_POST["roomOccupDate"];
    $datestart = $date." 00:00:00";
    $dateend = $date." 23:59:59";
    
   try {
        # sql
        $sql = "SELECT room_id, start_time, end_time
                FROM meeting
                WHERE start_time >= '$datestart' AND start_time <= '$dateend'
                ORDER BY room_id ASC";
               
        # prepare
        $stmt = $dbconn->prepare($sql);
        # the data we want to insert
        $data = array();
         # execute width array-parameter
        $stmt->execute($data);
        echo "Room occupation list for ".$date.":"."<br><br>";
        while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "Room ".$res["room_id"].": ".$res["start_time"]." - ".$res["end_time"]."<br>";
        }
        echo "<br>";
    }

    catch(PDOException $e){
      echo $sql . "<br>" . $e->getMessage();
    }
    
}


if(isset($_POST["addStaffParticipant"])){
	array_push($_SESSION["particUsers"], $_POST["userSelect"]);
}

if(isset($_POST["addPartnerParticipant"])) {
	array_push($_SESSION["particPartners"], $_POST["partnerSelect"]);
}

if(isset($_POST["clearParticipants"])){
    $_SESSION["particUsers"] = array();
    $_SESSION["particPartners"] = array();
}

$db = new DB();
$dbconn = $db->Connect();

$sql = "SELECT room_id FROM room";
$stmt = $dbconn->prepare($sql);
$stmt->execute();
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);

$sql = "SELECT user_id, user_name FROM user";
$stmt = $dbconn->prepare($sql);
$stmt->execute();
$userData = $stmt->fetchAll(PDO::FETCH_ASSOC);

$sql = "SELECT partner_id, name FROM business_partner";
$stmt = $dbconn->prepare($sql);
$stmt->execute();
$partnerData = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>

<form method="post">
    Select room:<br>
    <select name="roomSelect">
    <?php foreach ($data as $row): ?>
        <option value="<?php echo $row["room_id"]; ?>" 
		<?php // Update the selected from dropdown
		if (isset($roomid)) {
			if($row["room_id"] == $roomid) {
				echo 'selected="selected">';
			} 
			else { echo ">"; }
		} else { echo ">"; }
		?>
		<?php echo $row["room_id"]?>
		</option>
    <?php endforeach ?>
    </select>
    <button type="submit" name="showFacilities">Show facilities for selected room</button>
	<br />
    <br />
	
	<select name="userSelect">
    <?php foreach ($userData as $row): ?>
        <option value="<?php echo $row["user_id"]; ?>"><?=$row["user_name"]?></option>
    <?php endforeach ?>
    </select>
	<button type="submit" name="addStaffParticipant">Add a staff member as participant</button>
	<br />
	<select name="partnerSelect">
    <?php foreach ($partnerData as $row): ?>
        <option value="<?php echo $row["partner_id"]; ?>"><?=$row["name"]?></option>
    <?php endforeach ?>
    </select>
	<button type="submit" name="addPartnerParticipant">Add a business partner as participant</button>
	<br />
	<?php 
		echo "Current added participants:<br>";
		if (!empty($_SESSION["particUsers"])){
            $db = new DB();
            $dbconn = $db->Connect();
			foreach ($_SESSION["particUsers"] as $value){
				$sql = "SELECT user_name FROM user WHERE user_id='$value' " ; 
                $stmt = $dbconn->prepare($sql);
                $data = array();  
                $stmt->execute($data);
                $res = $stmt->fetch(PDO::FETCH_ASSOC);
                echo $res["user_name"]."<br>";
			}
		}
        if (!empty($_SESSION["particPartners"])){
            $db = new DB();
            $dbconn = $db->Connect();
			foreach ($_SESSION["particPartners"] as $value){
				$sql = "SELECT name FROM business_partner WHERE partner_id='$value' " ; 
                $stmt = $dbconn->prepare($sql);
                $data = array();  
                $stmt->execute($data);
                $res = $stmt->fetch(PDO::FETCH_ASSOC);
                echo $res["name"]."<br>";
			}
		}
	?>
	
    <button type="submit" name="clearParticipants">Clear participants</button><br/>	<br />
    Meeting start time:
    <input type="datetime-local" name="starttime"
	<?php // Def value taken from _post
		if (isset($startTimeHtml)) {
			echo "value=\"{$startTimeHtml}\" >";
		} else {
			echo ">";
		}
	?>
    <br>
    Meeting end time:
    <input type="datetime-local" name="endtime"
	<?php // Def value taken from _post
	if (isset($endTimeHtml)) {
		echo "value=\"{$endTimeHtml}\" >";
	} else {
		echo ">";
	}
	?>
    <button type="submit" name="showRoomByTime">Show available rooms</button>
	<br /><br />	
    <button type="submit" name="bookbutton">Book meeting</button>
    
    <h4>Room occupation</h4>
    <input type="date" name="roomOccupDate">
    <button type="submit" name="roomOccupButton">View room occupation list for date</button>
    
</form>

<?php
include("footer.php");
?>
