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
<h1>Особистий кабінет користувача</h1>
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


<?php

/// Вставка перехода в кабинет

$this->widget('mff.components.CabinetWidget');
//$this->widget('mff.components.CabinetWidget',array("cabinetId"=>1));
return; // ОТКЛЮЧИЛ ИЗ-ЗА ТОГО ЧТО ЛОКАЛЬНО ТЕСТИРОВАТЬ НЕЛЬЗЯ (НЕ ПРОХОДИТ АВТОРИЗАЦИЯ)
/// Конец вставки

}
?>
