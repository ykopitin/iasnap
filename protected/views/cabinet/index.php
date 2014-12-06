<?php
if (isset(Yii::app()->user->id)) {

if(CabUser::model()->findByPk(Yii::app()->user->id)->user_roles_id<4) {
$this->layout='maincabinet';

/// Вставка перехода в кабинет
$urlparam=array(
    "cabineturl"=>  base64_encode("application.views.cabinet.index"),
    "thisrender"=>  base64_encode("application.views.cabinet.index"),
);
if (isset($addons) && $addons!=NULL) $urlparam=array_merge($urlparam,array("addons"=>$addons));
$this->widget('mff.components.CabinetWidget',$urlparam);

 } 

if(Yii::app()->user->checkAccess('customer') ) { 


if (!isset($_GET['cabmin'])) {$cabmin=1;} else {$cabmin=$_GET['cabmin'];}
?>
<div id="shortblockserv">

<div id="shortblocktext">
<table>
	<tr>
		<td><ul>
<?php if ($cabmin==1) { echo '<li class="active">';} else { echo '<li>';} ?>

<a href=?cabmin=1>
Заявки</a></li>
<?php if ($cabmin==2) { echo '<li class="active">';} else { echo '<li>';} ?>
<a href=?cabmin=2>
Мої персональні дані</a></li></ul>
                </td>
        <td style="border-bottom: 4px;"></td>
	</tr>
</table>
</div>

</div>

<?php

}




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
<?php  if(Yii::app()->user->checkAccess('customer')  && ($cabmin==2)) { ?>
<h3>Ласкаво просимо до Вашого особистого кабінету</h3>
<p>Тут Ви можете переглянути статус та історію Ваших заявок. Для цього користуйтеся навігацію зліва (дані загружаються з сертифікату і їх змінити неможливо).</p>

<div id=cabper><form action="<?php echo Yii::app()->baseUrl; ?>/cabinet" method="post">
<table>
<tr><td colspan=2 style="text-align: center;"></td></tr>
<tr><td><b>ПІБ</b></td><td><input type="text" disabled="true" name="nm" id="cab" value="<?php echo CabUser::model()->findByPk(Yii::app()->user->id)->fio;?>"></td></tr>
<tr><td><b>Телефон</b></td><td><input type="text" name="fone" id="cab" value="<?php echo CabUser::model()->findByPk($usid)->phone;?>"></td></tr>
<tr><td><b>E-mail</b></td><td><input type="text" name="mail" id="cab" value="<?php echo CabUser::model()->findByPk($usid)->email;?>"></td></tr>
<tr><td colspan=2 style="text-align: center;"><br><input type=submit value="Зберегти зміни" class="cabperb">
<?php
if ($ok==1) {
    echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/ok.png style="margin-left: -35px; margin-bottom: -5px;">';
    }
?>
</td></tr>
</table>
</div>


<?php 

?>
</form>
<br />
<?php 

} 


if (Yii::app()->user->checkAccess('customer')  && ($cabmin==1)) {
if (empty($folderid)) $folderid=null;
/// Вставка перехода в кабинет
$urlparam=array(
    "cabineturl"=>  base64_encode("application.views.cabinet.index"),
    "thisrender"=>  base64_encode("application.views.cabinet.index"),
    "folderId" => $folderid,
);
if (isset($addons) && $addons!=NULL) $urlparam=array_merge($urlparam,array("addons"=>$addons));
$this->widget('mff.components.CabinetWidget',$urlparam);
}}
else {
Yii::app()->request->redirect('sign/login');
}
?>
</div>