<?php
/* @var $this GenCatClassesController */
/* @var $model GenCatClasses */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління довідниками'=>array('default/id4'),
	'Таблиця «Зв\'язок категорій з класами»'=>array('index'),
	$model->id,
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Оновити', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Вилучити', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Ви впевнені, що бажаєти вилучити дані?')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Відобразити Таблиця «Зв'язок категорій з класами» запис №<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'categorie_id',
		'class_id',
	),
)); ?>
