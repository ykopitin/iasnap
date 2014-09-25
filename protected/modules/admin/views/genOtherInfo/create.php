<?php
/* @var $this GenOtherInfoController */
/* @var $model GenOtherInfo */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління загальним інтерфейсом порталу'=>array('default/id1'),
	'Таблиця «Посилання на статті до категорій сайту»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Посилання на статті до категорій сайту»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>