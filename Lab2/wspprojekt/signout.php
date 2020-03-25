<?php
include("init.php");

	unset($_SESSION["currentusername"]);
    unset($_SESSION["currentuserid"]);
    unset($_SESSION["currentuserlevel"]);
    unset($_SESSION["particUsers"]);
    unset($_SESSION["particPartners"]);
    header("Location:index.php");
?>
