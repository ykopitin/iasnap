<?php
/* @var $this GenRegulationsController */
/* @var $model GenRegulations */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління загальним інтерфейсом порталу'=>array('default/id1'),
	'Таблиця «Відомості про нормативно-правові акти»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Відомості про нормативно-правові акти»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>