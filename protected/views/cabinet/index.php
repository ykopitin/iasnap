<?php
if (isset(Yii::app()->user->id)) {
$usid=Yii::app()->user->id;

/// Вставка перехода в кабинет

$this->widget('mff.components.CabinetWidget',array("cabinetId"=>1));
return; // ОТКЛЮЧИЛ ИЗ-ЗА ТОГО ЧТО ЛОКАЛЬНО ТЕСТИРОВАТЬ НЕЛЬЗЯ (НЕ ПРОХОДИТ АВТОРИЗАЦИЯ)
/// Конец вставки

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
<p>Шановний(на) <b><?php echo CabUserExternal::model()->findByPk($usid)->fio;?></b>!</p>
<p> Ласкаво просимо до Вашого особистого кабінету.
Тут Ви можете продивитися статус та історію Ваших заяв, або переглянути та змінти Ваші персональні дані. </p>
 <form action="<?php echo Yii::app()->baseUrl; ?>/index.php/cabinet" method="post">
 Ваш e-mail:
 <input type="text" name="mail" id="cab" value="<?php echo CabUser::model()->findByPk($usid)->email;?>">
               
Ваш телефон:<input type="text" name="fone" id="cab" value="<?php echo CabUser::model()->findByPk($usid)->phone;?>">
<input type="submit" value="Зберегти зміни">
<?php 
if ($ok==1) {
    echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/ok.png>';
    }
?>
</form>


<br />

<?php 
if (count($rows)>0){
?>
<h3>Замовлені послуги:</h3>
<table border="1" width="100%" id="table1">
	<tr>
		<td id="ctitle" width="2%"><span lang="uk">№</span></td>
        <td id="ctitle" width="12%"><span lang="uk">Дата подання</span></td>
        <td id="ctitle" width="10%"><span lang="uk">Трек-номер</span></td>
		<td id="ctitle" width="50%">Перелік послуг </td>
		<td id="ctitle" width="7%">Оплата</td>
		<td id="ctitle" width="5%">Статус </td>
        <td id="ctitle" width="15%">Документи</td>
	</tr>
    
    
    
  <?php 
  foreach($rows as $row) {
    ?>  
	<tr>
		<td><?php echo $i;?></td>
		<td><?php echo Yii::app()->dateFormatter->format("dd/MM/yyyy hh:mm", $row['bid_created_date']);?></td>
        <td><a href="#"><?php echo GenBidCurrentStatus::model()->findByPk($row['id'])->bid_id;?></a></td>
		<td><?php echo GenServices::model()->findByPk($row['services_id'])->name;?></td>
		<td><?php echo $row['payment_status'];?></td>
		<td><?php echo GenBidCurrentStatus::model()->findByPk($row['id'])->status_id;?></td>
        <td>Подані: 
        <?php 
        $c = new CDbCriteria;
        $c->compare('user_bid_id', $row['id']);
        $r=CabUserFilesIn::model()->findAll($c);  
        foreach($r as $row) {
            
            echo '<a href=#>1.'.$row['extension'].'</a>';
        }
        ?>
        
        </td>
	</tr>
    <?php
$i++;
}

?>
</table>
<?php
}
else {echo "Замовлених послуг ще нема.";}
?>
</div>

<?php } ?>