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
// #### admincp/index.php ####

include("config.php");
include("templates.php");





access();




echo $header;




echo ('Welcome to your poll administration panel. Your current poll is shown below. To replace it, click New poll above. <h4>Current poll results</h4>');


	//display results

	
	
	$poll = mysql_fetch_array(mysql_query("select * from fpoll_poll"));
	$totalvotes = $poll['totalvotes'];
	$question = $poll['question'];
			
	echo("<div class=poll>$question<br /><br />");
	
	$get_questions = mysql_query("select * from fpoll_options");
	while($r=mysql_fetch_array($get_questions)){
	
	
		extract($r);
		if($votes=="0"){
			
			$per = '0';
			
		}else{
			
			$per = $votes * 100 / $totalvotes;
			
		}
		$per = floor($per);
		
		echo($field); 
		?> <strong><?php echo("$votes"); ?></strong><br />
		<div style="background-color: <?php echo config(bg1); ?>;"><div style="color: <?php echo config(text); ?>; font-size: <?php echo config(size); ?>px; text-align: right; background-color: <?php echo config(bg2); ?>; width: <?php echo($per); ?>%;"><?php echo("$per%"); ?></div></div>
		<?php
			
	}
	
	echo("<br />Total votes: <strong>$totalvotes</strong></div>"); 
	



echo $footer;



?>


