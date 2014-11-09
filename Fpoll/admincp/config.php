<?php

// Author: PHPFront.com  2005
// License: Free (GPL)
//
// Version: 1.1
//
// Created: 8.12.2005 
//
// More information and downloads 
// available at http://www.PHPFront.com
//
// #### config.php ####


//database variables
$host = 'localhost';
$user = 'iasnap';
$pass = 'iasnap98';
$dbname = 'cnap_portal';


	

//connect to the mysql database
$mysql = mysql_connect($host,$user,$pass);
$db = mysql_select_db($dbname,$mysql); 


//grab config vars


function config($config) {
	
	$get_config = mysql_fetch_array(mysql_query("select * from fpoll_config"));
	$config = $get_config[$config];
	return $config;
	
	
}

function access() {
	
	
	if($_COOKIE['user']){
		
		
		$user = $_COOKIE['user'];
		$pass = $_COOKIE['pass'];
		
		$checkuser = mysql_query("SELECT * FROM fpoll_config WHERE user='$user' AND pass='$pass'");
		$returned = mysql_num_rows($checkuser);
		
		if($returned=="1"){
			//continue loading page..
		}
		else{
			
		
		
			include("templates.php");
		
			echo $login_header;
		
		
			?>
			<form action="login.php" method="post">
			<table cellspacing="1" cellpadding="4" border="0" bgcolor="#f2f2f2">
			<tr><td width="130">User</td><td><input type="text" name="user" /></td></tr>
			<tr><td>Password</td><td><input type="password" name="pass" /></td></tr>
			</table><br />
			<input type="hidden" name="referer" value="<?php echo $_SERVER['REQUEST_URI']; ?>" />
			<input type="submit" value="Login" name="login" />
			</form>
			<?php
		
			echo $footer;
		
		
			exit;
		
		}
		
	}else{
		
		include("templates.php");
		
		echo $login_header;
		
		
		?>
		<form action="login.php" method="post">
		<table cellspacing="1" cellpadding="4" border="0" bgcolor="#f2f2f2">
		<tr><td width="130">User</td><td><input type="text" name="user" /></td></tr>
		<tr><td>Password</td><td><input type="password" name="pass" /></td></tr>
		</table><br />
		<input type="hidden" name="referer" value="<?php echo $_SERVER['REQUEST_URI']; ?>" />
		<input type="submit" value="Login" name="login" />
		</form>
		<?php
		
		echo $footer;
		
		
		exit;
		
		
		
	}
	
	
	
}


	
?>