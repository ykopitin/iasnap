<?php
/* @var $this GenServCatConController */
/* @var $model GenServCatCon */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління послугами'=>array('default/id2'),
	'Таблиця «Звязок послуг з категоріями»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Звязок послуг з категоріями»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>