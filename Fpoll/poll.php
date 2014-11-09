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
// #### poll.php ####



include("admincp/config.php");

$totalvotes='';

$user_ip = $_SERVER['REMOTE_ADDR'];

$ipquery = mysql_query("SELECT * FROM fpoll_ips WHERE ip='$user_ip'");
$select_banned = mysql_num_rows($ipquery);

if($select_banned){

	//display results
	
	
	$poll = mysql_fetch_array(mysql_query("select * from fpoll_poll"));
	$question = $poll['question'];
	
	$countvotes = mysql_query("select votes from fpoll_options");
	while ($row = mysql_fetch_assoc($countvotes)) {
    	$totalvotes += $row["votes"];
	}
			
	echo("<div class=poll> <p class=polltit>Опитування</p><Br><div id=pollquestion>$question</div><br /><br />");
	
	$get_questions = mysql_query("select * from fpoll_options");
	while($r=mysql_fetch_array($get_questions)){
	
	
		extract($r);
		$per = $votes * 100 / $totalvotes;
		$per = floor($per);
		
		echo htmlspecialchars($field); 
		?> <strong><?php echo("$votes"); ?></strong><br />
		<div style="background-color: #D7D7D7;"><div style="color: #000; font-size: 14; ?>px; text-align: right;background-color: #4795C3; ?>; width: <? echo($per); ?>%;"><? echo("$per%"); ?></div></div>
		<?php
			
	}
	
	echo("<br />Всього проголосовали: <strong>$totalvotes</strong></div>"); 
	
	
	
	
	
}else{





//if the submit button was pressed
if(isset($_POST['submit'])){
	
	//grab vars
	$vote = $_POST['vote'];
	$refer = $_POST['refer'];
	
		
	//update numbers
	$update_totalvotes = "UPDATE fpoll_poll SET totalvotes = totalvotes + 1";
	$insert = mysql_query($update_totalvotes);
	
	$update_votes = "UPDATE fpoll_options SET votes = votes + 1 WHERE id = $vote";
	$insert = mysql_query($update_votes);
			
	//add ip to stop multiple voting
	$ip = $_SERVER['REMOTE_ADDR'];
	$addip = mysql_query("INSERT INTO fpoll_ips (ip)". "VALUES ('$ip')"); 

	
	//send the user back to thepage they were just viewing
	header("Location: $refer");
	
	
		
}	

	$uri = $_SERVER['REQUEST_URI'];
	
	//display the form!
	?>
    <div class="poll">
   <p class="polltit">Опитування</p>
   <br />Нам важлива ваша думка
    
    
    <form action="<?php echo $_SERVER['PHP_SELF'];?>" method="post"><?php
		
	$poll = mysql_fetch_array(mysql_query("select * from fpoll_poll"));
	$question = $poll['question'];
			
	echo("<div id=pollquestion>$question</div><br /><br />");
	
	
	$getcurrent = mysql_query("select * from fpoll_options ORDER by id");
	while($r=mysql_fetch_array($getcurrent)){
		
		extract($r);
		
		?><input type="radio" name="vote" value="<?php echo($id); ?>" class="radiobutton" /> <?php echo($field); ?><br /><?php
		
	}	
		
		
	?>
	<input type="hidden" name="refer" value="<?php echo $_SERVER['PHP_SELF']; ?>" /><br />
	<input type="submit" class="pollbutton" name="submit" value="ВІДПОВІСТИ"/> 
	</form></div>
	<?php	
	
	
	
}



?>