<?php
/* @var $this CabUserInternalController */
/* @var $model CabUserInternal */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління користувачами'=>array('default/id3'),
	'Таблиця «Каталог внутрішніх користувачів порталу»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Каталог внутрішніх користувачів порталу»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>