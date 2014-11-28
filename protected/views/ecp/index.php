
<div id="pagetit">Як отримати ЕЦП</div>

<?

$rows=GenOtherInfo::model()->findAllByAttributes(array('kind_of_publication'=>'10'));  
         
foreach($rows as $row) 
{ 

      echo  $row['text'];
  
}


?>