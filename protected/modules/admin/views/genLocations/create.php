<?php
/* @var $this GenLocationsController */
/* @var $model GenLocations */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління довідниками'=>array('default/id4'),
	'Таблиця «Відомості про населені пункти»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Відомості про населені пункти»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>