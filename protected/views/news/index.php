<?php

if ($_GET['idn']=='all'){
    ?>
    <div id="pagetit">Архів новин</div>
    <div id="archnewsall">
   <?php 
   
  $rows=GenNews::model()->findall(); 
 
   
   
   foreach($rows as $row) {
    echo '<table><tr><td  style="width: 200px;" rowspan="3"><img src=/images/news/'.GenNews::model()->findByPk($row['id'])->img.' style="width: 200px;"></td>';
    echo '<td><font face="arial" sans-serif color=#000 size=2><b>'.Yii::app()->dateFormatter->format("dd MMMM yyyy", $row['publicationDate']).'</b></font></td></tr>';
    echo '<tr><td><a href='.Yii::app()->request->baseUrl.'/index.php/news?idn='.$row['id'].'>'.$row['title'].'</a></td></tr>';
    echo '<tr><td><font color=#808080><p align="justify">'.$row['summary'].'</p></font></td></tr></table><br>';
   }
   
   echo '</div>';
}
else
{
?>

<div id="newsd">
<div id="archnews1"><a href="/news/?idn=all#anchor1">Архів новин</a></div>
<?
echo '<div id="posnamebg"><div id=posname><font color=#076c8e>'.GenNews::model()->findByPk($_GET['idn'])->title.'</font></div></div><hr>';
echo '<div id=allnewstext>' ;
echo GenNews::model()->findByPk($_GET['idn'])->text.'</div>';


?>

</div>

<?php

}
?>