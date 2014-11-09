<?php
/* @var $this NewsController */

$this->breadcrumbs=array(
	'Новини',
);
?>

<div id="newsd">
<< <a href="#" onclick="history.back();">Назад</a><br /><br />
<?
echo '<div id="posnamebg"><div id=posname>'.GenNews::model()->findByPk($_GET['idn'])->title.'</div></div>';
echo '<div id=allnewstext>'.GenNews::model()->findByPk($_GET['idn'])->img;
echo GenNews::model()->findByPk($_GET['idn'])->text.'</div>';


?>

</div>