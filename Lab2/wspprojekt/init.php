<?php
session_start();
include("classes\DB.php");
include("classes\User.php");
include("classes\Category.php");
include("classes\Thread.php");
include("classes\Post.php");

$user = null;


	
if(isset($_SESSION["currentuserlevel"]) && $_SESSION["currentuserlevel"] == 0){
	$user =  new User();
	$user->setAll($_SESSION["currentusername"]);
}

if(isset($_SESSION["currentuserlevel"]) && $_SESSION["currentuserlevel"] == 1){
	$user = new Admin();
	$user->setAll($_SESSION["currentusername"]);
}

include("header.php");