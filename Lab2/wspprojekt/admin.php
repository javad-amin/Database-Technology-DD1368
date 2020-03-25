
<?php
include("init.php");
include("functions\checkiflogged.php");
echo "<form method='post'>";

if(!isset($_SESSION["currentuserlevel"]) || $_SESSION["currentuserlevel"] == 0){
	header("Location:index.php");
}

if(isset($_POST["addteambutton"])){
    $db = new DB();
	$dbconn = $db->Connect();
    
    $teamname = $_POST["teamnametxt"];
    try {
		    # sql
		    $sql = "INSERT INTO team (name) 
		    VALUES (?)";
		    # prepare
		    $stmt = $dbconn->prepare($sql);
		    # the data we want to insert
		    $data = array($teamname);
		     # execute width array-parameter
		    $stmt->execute($data);
		    
		    $message = "Team added";
		    echo $message;
		}

		catch(PDOException $e){
            echo $sql . "<br>" . $e->getMessage();
		}
}

if(isset($_POST["removeteambutton"])){
    $db = new DB();
	$dbconn = $db->Connect();
    
    $teamid = $_POST["teamSelect"];
    try {
		    # sql
		    $sql = "DELETE FROM team WHERE team_id = ?";
		    # prepare
		    $stmt = $dbconn->prepare($sql);
		    # the data we want to insert
		    $data = array($teamid);
		     # execute width array-parameter
		    $stmt->execute($data);
		    
		    $message = "Team removed";
		    echo $message;
		}

		catch(PDOException $e){
            echo $sql . "<br>" . $e->getMessage();
		}
}


///////// Remove user

if(isset($_POST['removeuserbutton'])){
    $user->removeUser($_POST['userid']);
}
////////////////////////////////////////////////////////////////////////////////////////

if(isset($_POST['showUserBookings'])){
    $db = new DB();
	$dbconn = $db->Connect();
    
   try {
        # sql
        $sql = "SELECT meeting_id, user_id, start_time, end_time
                FROM meeting
                ORDER BY user_id ASC";
               
        $stmt = $dbconn->prepare($sql);
        $data = array();
        $stmt->execute($data);
        echo "Users meeting bookings:<br><br>";
        while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "User: ".$res["user_id"]." | Meeting: ".$res["meeting_id"]." | ".$res["start_time"]." - ".$res["end_time"]."<br>";
        }
        echo "<br>";
    }

    catch(PDOException $e){
      echo $sql . "<br>" . $e->getMessage();
    }
}

if(isset($_POST['showCosts'])){
    $db = new DB();
	$dbconn = $db->Connect();
    
    $starttime = str_replace("T"," ",$_POST["starttime"]).":00";
    $endtime = str_replace("T"," ",$_POST["endtime"]).":00";
    $diffInMin = (strtotime($endtime) - strtotime($starttime))/60;
    
   if($diffInMin > 0){
       try {
            # sql
            $sql = "SELECT name, SUM(cost)
                    FROM team_totalcost_log
                    WHERE start_time >= '$starttime'
                    AND start_time <= '$endtime'
                    GROUP BY name
                    ORDER BY SUM(cost) DESC";
                  
                   
            $stmt = $dbconn->prepare($sql);
            $data = array();
            $stmt->execute($data);
            echo "Accrued team costs ".$starttime." - ".$endtime."<br><br>";
            while ($res = $stmt->fetch(PDO::FETCH_ASSOC)) {
                echo "Team: ".$res["name"]." | Cost: ".$res["SUM(cost)"]."<br>";
            }
            echo "<br>";
        }

        catch(PDOException $e){
          echo $sql . "<br>" . $e->getMessage();
        }
   }
}

// Select all teams
$db = new DB();
$dbconn = $db->Connect();

$sql = "SELECT * FROM team";
$stmt = $dbconn->prepare($sql);
$stmt->execute();
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);

?>
<h4>Show users bookings</h4>
<button type="submit" name="showUserBookings">Show users bookings</button><br>

<h4>Show accrued team costs by time interval</h4>
Start time:
<input type="datetime-local" name="starttime">
<br>
End time:
<input type="datetime-local" name="endtime"><br><br>
<button type="submit" name="showCosts">Show accrued costs</button><br>

<h4>Remove user</h4>
<input type="text" name="userid" placeholder="User ID"></input><br><br>
<button type="submit" name="removeuserbutton">Remove user</button><br>

<h4>Add team</h4>
<input type="text" name="teamnametxt" placeholder="Team name"></input><br><br>

<button type="submit" name="addteambutton">Add team</button><br>

<h4>Remove team</h4>
Team:<br>
<select name="teamSelect">
 <?php foreach ($data as $row): ?>
    <option value="<?php echo $row["team_id"]; ?>"><?=$row["name"]?></option>
<?php endforeach ?>
</select>
<br><br>

<button type="submit" name="removeteambutton">Remove team</button><br>

</form>

<?php
include("footer.php");
?>
