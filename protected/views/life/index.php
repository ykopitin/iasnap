<div id="pagetit">Послуги за життєвими ситуаціями</div>


<div id="lifesit"><table>
<?php
$criteria = new CDbCriteria;
$criteria->compare('visability','так');
$criteria->order = 'name';
$rows1=GenLifeSituation::model()->findAll($criteria);
                 
        foreach($rows1 as $row) 
        {
            
$rows=GenServLifeSituations::model()->findAllByAttributes(array('life_situation_id'=>$row['id']));      
$scount=count($rows) ;                  
if ($scount>0){
echo '<tr><td width=33px><img src='.Yii::app()->baseUrl.'/images/life_icons/'.$row['icon'].' align=left></td><td><a href='.Yii::app()->request->baseUrl.'/index.php/serv/?life='.$row['id'].'>'.$row['name'].' </font></a><font color=gray size=2>('.$scount.')<td></tr>';
}
}
?>
</table>
</div>
