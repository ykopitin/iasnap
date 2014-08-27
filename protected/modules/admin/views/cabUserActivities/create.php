<?php
/* @var $this CabUserActivitiesController */
/* @var $model CabUserActivities */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління користувачами'=>array('default/id3'),
	'Таблиця «Відомості про активність користувачів»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Відомості про активність користувачів»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>