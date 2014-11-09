<?php

if (isset($_GET['servid'])) {
$rows1=GenServCatClass::model()->getIdService($_GET['servid']);

if (!empty($rows1)){
?>
<h3>Послуги:</h3>

<div id="poslugy">
<?php
$srow=GenServCatClass::model()->getIdService($_GET['servid']);
$col=count($srow);
if ($col <= 10) {
    
   ?> 
      <ol> <table cellpadding="6">
<?php
$criteria = new CDbCriteria;
$criteria->compare('id', $srow);
$criteria->order = 'name';
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td>';
     
   echo ' <a href='.Yii::app()->request->baseUrl.'/service?class='.$_GET['class'].'&&param='.$row['id'].'&&servid='.$_GET['servid'].'#anchor1>'.$row['name'].'</a>';
   echo ' </td></tr>';
       }
      
?></table></ol>
    
  <?php  
    
}



else {
    ?>
<div id="smallpos">
   <table cellpadding="6">
<?php
$criteria = new CDbCriteria;
$criteria->compare('id', $srow);
$criteria->order = 'name';
$criteria->limit = 10;
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?class='.$_GET['class'].'&&param='.$row['id'].'&&servid='.$_GET['servid'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table>
 <div id="showall"> <a href="#" onClick="document.getElementById('smallpos').style.display='none';document.getElementById('bigpos').style.display='';return false;">  Показати всі послуги (ще <?php echo $col-10; ?>) </a>&nbsp;<img src="<?php echo Yii::app()->baseUrl; ?>/images/down.gif">
</div> </div>      


<div id="bigpos" style="display:none">
  <table cellpadding="6">
<?php

$srow=GenServCatClass::model()->getIdService($_GET['servid']);
$criteria = new CDbCriteria;
$criteria->compare('id', $srow);
$criteria->order = 'name';
$criteria->limit = '10';
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?class='.$_GET['class'].'&&param='.$row['id'].'&&servid='.$_GET['servid'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table>
<p id="sall">
<table cellpadding="6">
<?php

$criteria1 = new CDbCriteria;
$criteria1->compare('id', $srow);
$criteria1->order = 'name';
$criteria1->offset = '10';
$criteria1->limit = '250';
$rows1=GenServices::model()->findAll($criteria1);

foreach($rows1 as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?class='.$_GET['class'].'&&param='.$row['id'].'&&servid='.$_GET['servid'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table></p>
   <div id="showall">  <a href="#" onClick="document.getElementById('bigpos').style.display='none';document.getElementById('smallpos').style.display='';return false;">   Скрити послуги   </a>&nbsp;<img src="<?php echo Yii::app()->baseUrl; ?>/images/up.gif">
</div></div><?php } ?>
<br />
<hr />
</div>

<?php
}

?>
<?php } 




//-----------------------------------------------------------------------------------


if (isset($_GET['sub'])) {

?>
<h3>Послуги:</h3>

<div id="poslugysub">
<?php
$srow=GenServices::model()->findAllByAttributes(array('subjwork_id'=>$_GET['sub']));  


$col=count($srow);
if ($col <= 10) {
    
   ?> 
      <ol> <table cellpadding="6">
<?php

$criteria = new CDbCriteria;
$criteria->compare('subjwork_id', $_GET['sub']);
$criteria->order = 'name';
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td>';
     
   echo ' <a href='.Yii::app()->request->baseUrl.'/service?sub='.$_GET['sub'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a>';
   echo ' </td></tr>';
       }
       
?></table></ol>
    
  <?php  
    
}



else {
    ?>
<div id="smallpos">
   <table cellpadding="6">
<?php
$criteria = new CDbCriteria;
$criteria->compare('subjwork_id', $_GET['sub']);
$criteria->order = 'name';
$criteria->limit = 10;
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?sub='.$_GET['sub'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table>
 <div id="showall"> <a href="#" onClick="document.getElementById('smallpos').style.display='none';document.getElementById('bigpos').style.display='';return false;">  Показати всі послуги (ще <?php echo $col-10; ?>) </a>&nbsp;<img src="<?php echo Yii::app()->baseUrl; ?>/images/down.gif">
</div> </div>      


<div id="bigpos" style="display:none">
  <table cellpadding="6">
<?php

$srow=GenServices::model()->findAllByAttributes(array('subjwork_id'=>$_GET['sub']));  
$criteria = new CDbCriteria;
$criteria->compare('subjwork_id', $_GET['sub']);
$criteria->order = 'name';
$criteria->limit = '10';
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?sub='.$_GET['sub'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table>
<p id="sall">
<table cellpadding="6">
<?php

$criteria1 = new CDbCriteria;
$criteria1->compare('subjwork_id', $_GET['sub']);
$criteria1->order = 'name';
$criteria1->offset = '10';
$criteria1->limit = '150';
$rows1=GenServices::model()->findAll($criteria1);

foreach($rows1 as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?sub='.$_GET['sub'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table></p>
   <div id="showall">  <a href="#" onClick="document.getElementById('bigpos').style.display='none';document.getElementById('smallpos').style.display='';return false;">   Скрити послуги   </a>&nbsp;<img src="<?php echo Yii::app()->baseUrl; ?>/images/up.gif">
</div></div><?php } ?>
<br />
<hr />
</div>


<?php } 






//-----------------------------------------------------------------------------------


if (isset($_GET['life'])) {

?>
<h3>Послуги:</h3>

<div id="poslugysub">
<?php
$srow=GenServLifeSituations::model()->findAllByAttributes(array('life_situation_id'=>$_GET['life']));  


$col=count($srow);

if ($col <= 10) {
    
   ?> 
      <ol> <table cellpadding="6">
<?php
foreach($srow as $row) {
$criteria = new CDbCriteria;
$criteria->compare('id', $row['service_id']);
$criteria->order = 'name';


$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td>';
     
   echo ' <a href='.Yii::app()->request->baseUrl.'/service?life='.$_GET['life'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a>';
   echo ' </td></tr>';
      } }
       
?></table></ol>
    
  <?php  
    
}



else {
    ?>
<div id="smallpos">
   <table cellpadding="6">
<?php
$criteria = new CDbCriteria;
$criteria->compare('id', $row['service_id']);
$criteria->order = 'name';
$criteria->limit = 10;
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?life='.$_GET['life'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table>
 <div id="showall"> <a href="#" onClick="document.getElementById('smallpos').style.display='none';document.getElementById('bigpos').style.display='';return false;">  Показати всі послуги (ще <?php echo $col-10; ?>) </a>&nbsp;<img src="<?php echo Yii::app()->baseUrl; ?>/images/down.gif">
</div> </div>      


<div id="bigpos" style="display:none">
  <table cellpadding="6">
<?php

$srow=GenServLifeSituations::model()->findAllByAttributes(array('life_situation_id'=>$_GET['life']));  
$criteria = new CDbCriteria;
$criteria->compare('id', $row['service_id']);
$criteria->order = 'name';
$criteria->limit = '10';
$rows=GenServices::model()->findAll($criteria);

foreach($rows as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?life='.$_GET['life'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table>
<p id="sall">
<table cellpadding="6">
<?php

$criteria1 = new CDbCriteria;
$criteria->compare('id', $row['service_id']);
$criteria1->order = 'name';
$criteria1->offset = '10';
$criteria1->limit = '150';
$rows1=GenServices::model()->findAll($criteria1);

foreach($rows1 as $row) {
     if ($row['is_online']=='так') {$status='<div id="isonline">online</div>';} else {$status='';}
     echo '<tr><td>'.$status.'</td><td><a href='.Yii::app()->request->baseUrl.'/service?life='.$_GET['life'].'&&param='.$row['id'].'#anchor1>'.$row['name'].'</a></td></tr>';
       }
       
?></table></p>
   <div id="showall">  <a href="#" onClick="document.getElementById('bigpos').style.display='none';document.getElementById('smallpos').style.display='';return false;">   Скрити послуги   </a>&nbsp;<img src="<?php echo Yii::app()->baseUrl; ?>/images/up.gif">
</div></div><?php } ?>
<br />
<hr />
</div>


<?php } 










?>
