<?php
/* @var $this GenServicesController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління послугами'=>array('default/id2'),
	'Таблиця «Відомості про послуги»',
);

$this->menu=array(
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Таблиця «Відомості про послуги»</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
