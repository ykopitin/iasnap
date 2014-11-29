<?php
if (isset(Yii::app()->user->id)) {
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
<div id="cabinet">

<?php  if(Yii::app()->user->checkAccess('customer')) { ?>
<font  size=2 >Ви авторизовані як <?php echo CabUser::model()->findByPk(Yii::app()->user->id)->fio;?>.</font><br><br>

<br />



<p>Шановний(на) <b><?php echo CabUser::model()->findByPk($usid)->fio;?></b>!</p>
<p> Ласкаво просимо до Вашого особистого кабінету.
Тут Ви можете продивитися статус та історію Ваших заяв, або переглянути та змінти Ваші персональні дані. </p>
 <form action="<?php echo Yii::app()->baseUrl; ?>/index.php/cabinet" method="post">
 Ваш e-mail:
 <input type="text" name="mail" id="cab" value="<?php echo CabUser::model()->findByPk($usid)->email;?>">
               
Ваш телефон:<input type="text" name="fone" id="cab" value="<?php echo CabUser::model()->findByPk($usid)->phone;?>">
<input type="submit" value="Зберегти зміни" class="mybutton">
<?php 
if ($ok==1) {
    echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/ok.png>';
    }
?>
</form>





<br />
<?php } ?>

<?php

/// Вставка перехода в кабинет
$urlparam=array(
    "cabineturl"=>  base64_encode("application.views.cabinet.index"),
    "thisrender"=>  base64_encode("application.views.cabinet.index"),
);
if (isset($addons) && $addons!=NULL) $urlparam=array_merge($urlparam,array("addons"=>$addons));
$this->widget('mff.components.CabinetWidget',$urlparam);


}
?>
</div>