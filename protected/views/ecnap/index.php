
<div id="pagetit">Про електронний центр надання адміністративних послуг</div>
<div id="ecnapcss">
<?

$rows=GenOtherInfo::model()->findAllByAttributes(array('kind_of_publication'=>'6'));  
         
foreach($rows as $row) 
{ 

      echo  $row['text'];
  
}


?>
</div>