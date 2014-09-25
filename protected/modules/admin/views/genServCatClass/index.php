<?php
/* @var $this GenServCatClassController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління послугами'=>array('default/id2'),
	'Таблиця «Зв\'язок послуг з категоріями та класами»',
);

$this->menu=array(
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Таблиця «Зв'язок послуг з категоріями та класами»</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
