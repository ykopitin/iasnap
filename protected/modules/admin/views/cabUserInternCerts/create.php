<?php
/* @var $this CabUserInternCertsController */
/* @var $model CabUserInternCerts */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління користувачами'=>array('default/id3'),
	'Таблиця «Сертифікати внутрішніх користувачів»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Сертифікати внутрішніх користувачів»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>