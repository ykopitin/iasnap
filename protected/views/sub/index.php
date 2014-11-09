<div id="pagetit">Послуги за суб&#39єктами надання</div>


<div id="subject"><?php
$criteria = new CDbCriteria;
$criteria->compare('is_cnap','СНАП');
$criteria->order = 'name';
$rows1=GenAuthorities::model()->findAll($criteria);
                 
        foreach($rows1 as $row) 
        {
            
$rows=GenServices::model()->findAllByAttributes(array('subjwork_id'=>$row['id']));      
$scount=count($rows) ;                  
if ($scount>0){
echo '<a href='.Yii::app()->request->baseUrl.'/index.php/serv/?sub='.$row['id'].'>'.$row['name'].' &nbsp; <font color=gray size=2>('.$scount.')</font></a><Br>';
}
}
?>
<br />
</div>
