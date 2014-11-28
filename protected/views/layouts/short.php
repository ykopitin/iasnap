<div id="onl">
<?php

 if (GenServices::model()->findByPk($_GET['param'])->is_online=='так')
{
    
          
  if(Yii::app()->user->checkAccess('customer'))
			$url=$this->createUrl("usl/save",  array(
                       "idregistry"=>GenServices::model()->findByPk($_GET['param'])->ff_link,
                        "idstorage"=>16,  
 "addons"=>GenServices::model()->findByPk($_GET['param'])->id,
                         "thisrender"=>base64_encode("application.views.usl.index")                    
                    )
            );    
				else
					$url=Yii::app()->CreateUrl('sign/login');
    
?>




<table><tr><td><div id="otonline"><a href="<?php echo $url; ?>">ОТРИМАТИ ПОСЛУГУ ></a></div></td></tr></table>
<?php
}
$temp='';


  if (isset($_GET['class']) && isset($_GET['servid']) ) {$tempclass=$_GET['class']; $tempcat=$_GET['servid'];$count=1;} else {
    
    $rr=GenServCatClass::model()->findAllByAttributes(array('service_id'=>$_GET['param']));
$count=count($rr) ;
if ($count>0){
     foreach($rr as $row) 
        {
            $temp=$row['cat_class_id'];
    }
    $tempclass=GenCatClasses::model()->findByPk($temp)->class_id;
   // $tempcat=GenCatClasses::model()->findByPk($temp)->categorie_id;
    }
}



?><div id="shortblock">

<table>
	<tr>
		<td id="first"><h3>Державний орган</h3><?php echo GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjwork_id)->name;?></td>
	</tr>

<?php
if ($count){
?>
	<tr>
		<td><h3>Отримувач</h3><?php if ($tempclass=='1'){echo "Громадяни";} if ($tempclass=='2'){echo "Організації";}?></td>
	</tr>
<?php } ?>

	<tr>
		<td><h3>Місце надання послуги</h3><?php echo GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->name;?></td>
	</tr>
	<tr>
		<td><h3>Вартість послуги</h3><?php if (GenServices::model()->findByPk($_GET['param'])->is_payed=='1'){echo "Платно";} if (GenServices::model()->findByPk($_GET['param'])->is_payed=='0'){echo "Безоплатно";}?></td>
	</tr>
	<tr>
		<td style="border-bottom:0"><h3>Строк надання</h3><?php echo GenServices::model()->findByPk($_GET['param'])->deadline;?></td>
	</tr>
</table>


</div>

</div>