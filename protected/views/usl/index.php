<?php
 if(Yii::app()->user->checkAccess('customer')) {
$usid=Yii::app()->user->id;

$criteria = new CDbCriteria;
$criteria->compare('user_id', $usid);
$criteria->order = 'id';
$rows=CabUserBidsConnect::model()->findAll($criteria);   
$i=1;

if (isset($_POST['mail']) || isset($_POST['fone'])){
$em = CabUser::model()->findByPk($usid);
$em->email = $_POST['mail'];
$em->phone = $_POST['fone'];
$em->update(); 
$ok=1; 
}
else {$ok=0;}
?>

<h3>Шановний(на) <b><?php echo CabUser::model()->findByPk($usid)->fio;?></b>!</h3>
<p> Ви намагаєтесь замовити послугу: <font size=3 color="black">"<?php echo GenServices::model()->findByPk($_GET['addons'])->name;?>"</font></p>
<hr>
<p><font color=black>Додайте скановану копію заповнених та підписаних власноруч документів у форматі .pdf:</font></p>
<?php

        $ff=$this->widget('mff.components.FF.FFWidget',
                    array(
                        "idregistry"=>38,
                        "idstorage"=>16,
                        "backurl"=>  base64_encode($this->createUrl("application.cabinet")), 
			"profile"=>"usl",	
                )
            );
    $script="SubmitPetition('".$ff->name."');";
    echo CHtml::button("Надіслати заявку",array("onclick"=>$script, "class" => "mybutton"));
}
?> 
