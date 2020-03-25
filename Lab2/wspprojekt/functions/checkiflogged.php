<?php


if(!isset($_SESSION["currentuserid"])){
    unset($_SESSION["currentusername"]);
    unset($_SESSION["currentuserlevel"]);
    header("Location:login.php");
}