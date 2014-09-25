<?php
/* @var $this GenAuthoritiesController */
/* @var $model GenAuthorities */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління послугами'=>array('default/id2'),
	'Таблиця «Відомості про центри та субєкти»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Відомості про центри та субєкти»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>