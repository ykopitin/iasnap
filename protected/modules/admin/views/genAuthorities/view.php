<?php
/* @var $this GenAuthoritiesController */
/* @var $model GenAuthorities */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління послугами'=>array('default/id2'),
	'Таблиця «Відомості про центри та субєкти»'=>array('index'),
	$model->name,
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Оновити', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Вилучити', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Ви впевнені, що бажаєти вилучити дані?')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Відобразити Таблиця «Відомості про центри та субєкти» запис №<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'is_cnap',
		'type',
		'name',
		'locations_id',
		'index',
		'street',
		'building',
		'office',
		'working_time',
		'phone',
		'fax',
		'email',
		'web',
		'transport',
		'gpscoordinates',
		'photo',
	),
)); ?>
