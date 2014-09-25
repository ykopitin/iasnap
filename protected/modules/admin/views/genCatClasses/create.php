<?php
/* @var $this GenCatClassesController */
/* @var $model GenCatClasses */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління довідниками'=>array('default/id4'),
	'Таблиця «Зв\'язок категорій з класами»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Зв'язок категорій з класами»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>