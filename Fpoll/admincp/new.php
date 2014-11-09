<?php 

// Author: PHPFront.com � 2005
// License: Free (GPL)
//
// Version: 1.1
//
// Created: 8.12.2005 
//
// More information and downloads 
// available at http://www.PHPFront.com
//
// #### admincp/new.php ####

include("config.php");
include("templates.php");

access();

echo $header;




echo ('<h4>New Poll</h4>');


if($_POST['step1']){
	
	
	?><form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
	<table cellspacing="1" cellpadding="4" border="0" bgcolor="#f2f2f2"><tr>
	<td width="130">
	Poll Question: 
	</td>
	<td><input type="text" name="question" size="40" value="<?php echo $_POST['question']; ?>" />
	</td></tr>
	<tr><td colspan="2"><hr /></td></tr>
	<?php
	
	$i = 1;
	while ($i <= $_POST['options']) {
		
		
			
  		echo(" <tr><td>Question $i</td><td><input type='text' name='field[$i]' size='40' value='' /></td></tr> "); 
  		
  		
   		$i++;
   
	}

	echo('</tr></table><br /><input type="submit" name="step2" value="Submit!" /></form>');
	
	
	
}elseif($_POST['step2']){
	
	$question = addslashes($_POST['question']);
	
	
	//delete all previous poll data (no multiple polls yet, maybe later...)
	$delete_previous_options = mysql_query(" TRUNCATE `fpoll_options`");
	$delete_previous_poll = mysql_query(" TRUNCATE `fpoll_poll`");
	$delete_previous_ips = mysql_query(" TRUNCATE `fpoll_ips`");
	
	
	//insert new poll info
	$insert_new_poll = mysql_query("INSERT INTO fpoll_poll (id, question, totalvotes)" . "VALUES ('NULL', '$question', '0')");
	
	$field = $_POST['field'];
	
	//for each option
	foreach ($field as $value) {
						
		
		//add it to the database
		$add_fields = mysql_query("INSERT INTO fpoll_options (id, field, votes)" . "VALUES ('NULL', '$value', '0')"); 
		
	
}

	echo("Your poll is now ready!<br /><br /><a href=index.php>Home</a>");
	
	
	
}else{


	//our first form
	?>
	
	<form action="<?php $_SERVER['PHP_SELF']; ?>" method="post">
	<table cellspacing="1" cellpadding="4" border="0" bgcolor="#f2f2f2"><tr>
	<td width="130">
	Poll Question:
	</td>
	<td width="300">
	<input type="text" name="question" size="40" />
	</td></tr><tr>
	<td>
	Number of Options: 
	</td>
	<td>
	<input type="text" name="options" size="1" value="4" />
	</td></tr></table><br /><br />
	<input type="submit" name="step1" value="Continue!" />
	</form>
	<?php



}




echo $footer;



?>


