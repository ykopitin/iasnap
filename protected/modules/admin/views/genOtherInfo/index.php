<?php
/* @var $this GenOtherInfoController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління загальним інтерфейсом порталу'=>array('default/id1'),
	'Таблиця «Посилання на статті до категорій сайту»',
);

$this->menu=array(
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Таблиця «Посилання на статті до категорій сайту»</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,

	'itemView'=>'_view',
)); ?>
