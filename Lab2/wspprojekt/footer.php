</article>
		
		<?php
		if(isset($_SESSION["currentuserlevel"]) && $_SESSION["currentuserlevel"] == 0){
			$currentuserid = $_SESSION['currentuserid'];
			echo 
			"<nav>
			Menu<br><br>
			<a href='index.php'>Home</a><br>
			<a href='profile.php?user_id=$currentuserid'>Profile</a>
			</nav>";
		}

		else if(isset($_SESSION["currentuserlevel"]) && $_SESSION["currentuserlevel"] == 1){
			$currentuserid = $_SESSION['currentuserid'];
			echo 
			"<nav>
			Menu<br><br>
			<a href='admin.php'>Admin</a><br>
			<a href='index.php'>Home</a><br>
			<a href='profile.php?user_id=$currentuserid'>Profile</a>
			</nav>";
		}

		else{
			echo 
			"<nav>
			Menu<br><br>
			<a href='index.php'>Home</a><br>
			<a href='login.php'>Login</a><br>
			<a href='register.php'>Register</a>
			</nav>";
		}
		?>
		
		<aside>
		
		</aside>

	</section>

	<footer><p id="centertext">Created by Edin Suta</p></footer>

</body>
</html>