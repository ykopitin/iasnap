<?php

if (!isset($_GET['cid'])){
echo '<div id="pagetit">Контакти центрів</div>';




$rows=GenAuthorities::model()->findAllByAttributes(array('is_cnap'=>'ЦНАП'));  
foreach($rows as $row) 
{ 
echo '<div id="contcss"><a href=?cid='.$row['id'].'>'.$row['name'].'</a></div>';
}
}





if (isset($_GET['cid']))
{
$row=GenAuthorities::model()->findByPk($_GET['cid']);  
$this->renderPartial('info', array(
'row' => $row,    ));
}
?>



