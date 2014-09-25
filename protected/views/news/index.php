<?php
/* @var $this NewsController */

$this->breadcrumbs=array(
	'Новини',
);
?>

<div id="newsd">
<< <a href="#" onclick="history.back();">Назад</a><br /><br />
<?
echo '<h3>'.GenNews::model()->findByPk($_GET['idn'])->title.'</h3>';
echo '<img src='.GenNews::model()->findByPk($_GET['idn'])->img.' class=newsimg>';
echo GenNews::model()->findByPk($_GET['idn'])->text;


?>

</div>