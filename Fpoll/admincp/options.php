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
// #### admincp/options.php ####

include("config.php");
include("templates.php");


access();


echo $header;




echo ('<h4>Poll options</h4>');


if($_POST['options']){
	

	$bg1 = $_POST['bg1'];
	$bg2 = $_POST['bg2'];
	$text = $_POST['text'];
	$size = $_POST['size'];
	

	
	$options = "UPDATE fpoll_config SET bg1='$bg1',bg2='$bg2',text='$text',size='$size'";
	$update_options = mysql_query($options);
	
		echo("Optons updated.<br /><br />");
	
}

	
	
$config = mysql_fetch_array(mysql_query("select * from fpoll_config"));
$bg1 = $config['bg1'];
$bg2 = $config['bg2'];
$size = $config['size'];
$text = $config['text'];

			
?>
<form action="<? echo $_SERVER['PHP_SELF']; ?>" method="post">

<table cellspacing="1" cellpadding="4" border="0" bgcolor="#f2f2f2">

<tr><td width="130">Bgcolor1: </td><td style="border-right: 10px solid <? echo $bg1; ?>;"><input type="text" name="bg1" value="<? echo $bg1; ?>" size="20" /></td></tr>
<tr><td>Bgcolor2: </td><td style="border-right: 10px solid <? echo $bg2; ?>;"><input type="text" name="bg2" value="<? echo $bg2; ?>" size="20" /></td></tr>
<tr><td>Text color: </td><td style="border-right: 10px solid <? echo $text; ?>;"><input type="text" name="text" value="<? echo $text; ?>" size="20" /></td></tr>
<tr><td>Text size: </td><td><input type="text" name="size" value="<? echo $size; ?>" size="20" /></td></tr>
</table>
<br /><br />







<input type="submit" name="options" value="Submit" />
</form>


<?
	

	
	
	
	
	


echo $footer;



?>


