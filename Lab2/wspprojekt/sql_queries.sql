-- Lab 2

-- Start using the database
use bookingdb;

-- Insert a new user (Is done by the GUI)

/*  ------------------------------------------------------------------- Done
 Delete old users 
$user_id = input variabel by the user
PHP: A message should be shown confirming the deletation.
*/
DELETE FROM user 
WHERE user_id = $user_id;



/*  ------------------------------------------------------------------- Done
Insert teams 
$name = input variabel by the user
PHP: A message should be shown confirming the insertion.
*/
INSERT INTO team (name)
VALUES ($name);

/* Delete teams
$team_id = input variabel by the user
PHP: A message should be shown confirming the deletation.
*/ 
DELETE FROM team 
WHERE team_id = $team_id;


/*  ------------------------------------------------------------------- Done
What rooms are available for a given time slot 
$given_starting_time = input variabel by the user
$given_end_time = input variabel by the user
PHP: The content of this table should be shown to the user maybe collected with an array.
*/
/*
SELECT DISTINCT R.room_id 
FROM room as R
LEFT JOIN meeting as M ON R.room_id = M.room_id
WHERE ('$starttime' < M.start_time AND '$endtime' < M.start_time)
OR ('$starttime' > M.end_time AND '$endtime' > M.end_time)
OR (M.meeting_id IS NULL); */

SELECT room_id
					FROM room
					WHERE /* Meetings overlaped*/
						(SELECT DISTINCT room_id
							FROM meeting
							WHERE ('$starttime' BETWEEN start_time AND end_time)
							OR ('$endtime' BETWEEN start_time AND end_time)) != room_id 
						OR
						(SELECT DISTINCT room_id
							FROM meeting
							WHERE ('$starttime' BETWEEN start_time AND end_time)
							OR ('$endtime' BETWEEN start_time AND end_time)) IS NULL;



/*  ------------------------------------------------------------------- Done
Add new meetings, but reject attempts to book meetings that would overlap with already booked ones.
$user_id = The user whom is online
$room_id = input variabel by the user
$given_starting_time = input variabel by the user
$given_end_time = input variabel by the user
$booking_cost = ----
PHP: 
$available_array: first we use the above query with our given start and end time in order to get an 
array of all available rooms at the given time interval.
*/

/* allow the user to choose between rooms and view their facilities: $room_id
When room_id is selected from the database we need to show the facilities included in the room
to the user.
*/
SELECT B.name
	FROM facility_in as A
	INNER JOIN facility as B ON A.facility_id = B.facility_id
	WHERE A.room_id = $room_id;

/*
Now we need to calculate the price for the booking as $booking_cost.
Below we make a table of all rooms and the cost of the facility included in the room which could be saved in 
an associative array and then we can use the price for the room in question.

Lastley we need to add the formula for calculating the price for the time allocated for the meeting and add 
that to the $booking_cost which is the total cost for the booking. 
*/
SELECT A.room_id, SUM(B.facility_cost)
	FROM facility_in as A
	INNER JOIN facility as B ON A.facility_id = B.facility_id
	GROUP BY A.room_id;
	
/*
foreach ($available_array as $available_room) {
    if ($room_id = available_room) {
		// We run the bellow query for inserting into meeting
	} else {
		echo "Error: The room is already booked at this time."
	}
}
*/

INSERT INTO meeting (user_id, room_id, start_time, end_time, booking_cost)
VALUES ($user_id, $room_id, $given_starting_time, $given_end_time, $booking_cost);
SELECT LAST_INSERT_ID(); -- this line is used to get the meeting-id for the meeting which is inserted.
-- We save the id in a variable $meeting_id and use it to add prticipants to the meeting.

-- Getting the team id
-- $team_id, $team_name :: 
SELECT team_id, name
FROM user
WHERE user_id = $user_id;
	
-- Adding to the log of costs for teams
INSERT INTO team_totalcost_log (team_id, name, start_time, end_time, booking_cost)
VALUES ($team_id, $name, $given_starting_time, $given_end_time, $booking_cost);

/*
Select the people who are to attend a meeting.
First we need to add the user whom has created the meeting as a participant (Preferably automatic).
$meeting_id = Saved from LAST_INSERT_ID() function
$user_id = generated automatic, user which is online
$partner_id = null
*/
INSERT INTO participant (meeting_id, user_id)
VALUES ($meeting_id, $user_id);

/*
Now at this point the page should be redirected to a new page for adding other participants.
$meeting_id = Saved from LAST_INSERT_ID() function
$user_id = selectable from user table
$partner_id = selectable from partner table
*/
INSERT INTO participant (meeting_id, user_id)
VALUES ($meeting_id, $user_id);

-- OR

INSERT INTO participant (meeting_id, partner_id)
VALUES ($meeting_id, $partner_id);




/*  ------------------------------------------------------------------- Done
Delete meetings that have not occured yet.
$meeting_id = input variabel by the user

First by selecting a $meeting_id it would be nice to be able to see the details
about the booking (Not a requirement by the lab) maybe by saving the data from below query 
and outputting them to the GUI.
*/
SELECT * FROM meeting WHERE meeting_id = $meeting_id;

/*
check if the meeting has occured.
The start_time could be recorded in php a variable and then a php conditional 
statement can check if the (start_time < ACTUAL_TIME) and in case this is 
true we procced we deleting the meeing.
*/

/* reject attempts to cancel by any user who didn’t book that particular meeting
$user_id = generated autmatically, user whom is logged in

We use the below query to find out who has created the meeting and then by a php 
conditional check if the user has the authentication to delete the meeting.
*/
SELECT user_id from meeting WHERE meeting_id = $meeting_id;

/*
Deleting the data if the conditions are met.
*/

DELETE FROM meeting 
WHERE meeting_id = $meeting_id;



/*  ------------------------------------------------------------------- Done
Present occupation lists for all rooms on a given date. 
You can use MySQL's DATE() function to obtain only the date part of your TIMESTAMP: DATE(date).
$date = date input by the user, should be in the format: yyyy-mm-dd
Bellow gives all the meetings booked in a certain date sorted by the room id.
*/
SELECT *
FROM meeting
WHERE DATE($start_time) = $date OR DATE($end_time) = $date
ORDER BY room_id; 

/*  -------------------------------------------------------------------
Show which users have booked which meetings.
*/
SELECT A.meeting_id, B.name
	FROM meeting as A
	INNER JOIN user as B ON A.user_id = B.user_id;
	
/*  ------------------------------------------------------------------- DONE in profile
Show all participants of a given meeting. 
With the following query we get two coloums one for staff and the other for 
business partner names and it shouldn't be hard to save them all to an array 
and display them.*/
SELECT user.user_name, business_partner.name
	FROM ((participant
	LEFT JOIN user ON participant.user_id = user.user_id)
	LEFT JOIN business_partner ON participant.partner_id = business_partner.partner_id);
	
/*  -------------------------------------------------------------------
Show cost accrued by teams for any given time interval. 
$team_id = selection by user
$start_time, $end_time*/
SELECT FROM team_totalcost_log 
WHERE $team_id = team_id AND $start_time >= start_time AND $end_time <= end_time

/*  -------------------------------------------------------------------
TODO: 
1. no typing whatsoever, everything has to be selected from the database including 
the start_time and end_time.

2. The software is built for an insurance company, so it would be nice to have a 
position database with relevant staff positions .*/















