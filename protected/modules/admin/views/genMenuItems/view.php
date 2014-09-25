<?php
/* @var $this GenMenuItemsController */
/* @var $model GenMenuItems */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління загальним інтерфейсом порталу'=>array('default/id1'),
	'Таблиця «Пункти меню»'=>array('index'),
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

<h1>Відобразити Таблиця «Пункти меню» запис №<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'content',
		'paderntid',
		'url',
		'ref',
		'visability',
	),
)); ?>
