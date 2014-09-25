<?php
/* @var $this CabUserExternalController */
/* @var $model CabUserExternal */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління користувачами'=>array('default/id3'),
	'Таблиця «Каталог зовнішніх користувачів порталу»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Каталог зовнішніх користувачів порталу»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>