<?php
/* @var $this GenServicesController */
/* @var $model GenServices */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління послугами'=>array('default/id2'),
	'Таблиця «Відомості про послуги»'=>array('index'),
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

<h1>Відобразити Таблиця «Відомості про послуги» запис №<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'name',
		'subjnap_id',
		'subjwork_id',
		'regulations',
		'reason',
		'submission_proc',
		'docums',
		'is_payed',
		'payed_regulations',
		'payed_rate',
		'bank_info',
		'deadline',
		'denail_grounds',
		'result',
		'answer',
		'is_online',
	),
)); ?>
