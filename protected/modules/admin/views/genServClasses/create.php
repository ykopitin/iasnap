<?php
/* @var $this GenServClassesController */
/* @var $model GenServClasses */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління довідниками'=>array('default/id4'),
	'Таблиця «Каталог класів послуг»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Каталог класів послуг»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>