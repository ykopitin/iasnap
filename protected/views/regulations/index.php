
<div id="regcss">


<?php




$criteria = new CDbCriteria;
$criteria->order = 'type';
$criteria->group = 'type';
$rows=GenRegulations::model()->findAll($criteria);


foreach($rows as $row) 
{  
   echo '<p>'.$row['type'].':</p><ul>';
        $criteria1 = new CDbCriteria;
        $criteria1->order = 'name';
        $criteria1->compare('type', $row['type']);
        $rows1=GenRegulations::model()->findAll($criteria1);
        foreach($rows1 as $row) 
        {
        
         echo '<li><a href='.$row['hyperlink'].' target=_blank>'.$row['name'].'</a></li>';
        
        }
echo "</ul>";

}


?>
</div>