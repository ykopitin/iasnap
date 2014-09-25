<?php
/* @var $this GenMenuItemsController */
/* @var $model GenMenuItems */

$this->breadcrumbs=array(
	'Gen Menu Items'=>array('index'),
	$model->id,
);

$this->menu=array(
	array('label'=>'List GenMenuItems', 'url'=>array('index')),
	array('label'=>'Create GenMenuItems', 'url'=>array('create')),
	array('label'=>'Update GenMenuItems', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Delete GenMenuItems', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Are you sure you want to delete this item?')),
	array('label'=>'Manage GenMenuItems', 'url'=>array('admin')),
);
?>

<h1>View GenMenuItems #<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'content',
		'paderntid',
		'visability',
	),
)); ?>
