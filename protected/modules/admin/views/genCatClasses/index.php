<?php
/* @var $this GenCatClassesController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління довідниками'=>array('default/id4'),
	'Таблиця «Зв\'язок категорій з класами»',
);

$this->menu=array(
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Таблиця «Зв'язок категорій з класами»</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
