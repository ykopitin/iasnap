<?php
/* @var $this CabUserExternCertsController */
/* @var $model CabUserExternCerts */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління користувачами'=>array('default/id3'),
	'Таблиця «Сертифікати зовнішніх користувачів»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Сертифікати зовнішніх користувачів»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>