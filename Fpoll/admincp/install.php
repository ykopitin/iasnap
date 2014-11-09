<?php 

// Author: PHPFront.com © 2005
// License: Free (GPL)
//
// Version: 1.1
//
// Created: 8.12.2005 
//
// More information and downloads 
// available at http://www.PHPFront.com
//
// #### admincp/install.php ####

include("config.php");
include("templates.php");





echo $login_header;



if($_POST['install']){
	
	
	$user = $_POST['user'];
	$pass = md5($_POST['pass']);
	
	echo("Creating tables.......");

$install = "CREATE TABLE fpoll_config (
  user text NOT NULL,
  pass text NOT NULL,
  bg1 text NOT NULL,
  bg2 text NOT NULL,
  text text NOT NULL,
  size text NOT NULL
) TYPE=MyISAM;";
mysql_query($install);


$install = "CREATE TABLE fpoll_ips (
  ip text NOT NULL
) TYPE=MyISAM;";
mysql_query($install);


$install = "CREATE TABLE fpoll_options (
  id tinyint(4) NOT NULL auto_increment,
  field text NOT NULL,
  votes text NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;";
mysql_query($install);


$install = "CREATE TABLE fpoll_poll (
  id tinyint(4) NOT NULL auto_increment,
  question text NOT NULL,
  totalvotes smallint(6) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;";
mysql_query($install);

	echo("DONE<br /><br />");

	echo("Inserting data.......");
	
$install = "INSERT INTO fpoll_config VALUES ('$user', '$pass', '#D7D7D7', '#4795C3', '#000000', '11');";
mysql_query($install);


$install = "INSERT INTO fpoll_options VALUES (1, 'blue', '0');";
mysql_query($install);
$install = "INSERT INTO fpoll_options VALUES (2, 'yellow', '0');";
mysql_query($install);
$install = "INSERT INTO fpoll_options VALUES (3, 'green', '0');";
mysql_query($install);
$install = "INSERT INTO fpoll_options VALUES (4, 'brown', '0');";
mysql_query($install);



$install = "INSERT INTO fpoll_poll VALUES (1, 'What\'s your favourite color?', 0);";
mysql_query($install);

	
	echo("DONE<br /><br />");
	
	
	
	
	
	
	echo("<br /><br /><br />Your installation is now complete, please delete install.php immediately.<br /><br /><a href=index.php>Proceed to administration.</a>");
	
	
	
	
}else{


echo '<h4>1 Step Installation</h4>';



echo 'Installing Fpoll is easy, simply fill out the details below, and the install file will do the rest. Before continuing, make sure you edit your config.php file with your mysql details.<br /><br />

<form action="install.php" method="post">

<table cellspacing="1" cellpadding="4" border="0" bgcolor="#f2f2f2">

<tr><td colspan="2">Choose your administrator user and password.</td></tr>
<tr><td width=190">Username:</td><td><input type="text" name="user" /></td></tr>
<tr><td>Password:</td><td><input type="password" name="pass" /></td></tr>
</table><br />

<input type="submit" name="install" value="Next" />
</form>


';



}


echo $footer;


?>