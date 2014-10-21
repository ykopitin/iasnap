<?php
/* @var $this CabUserController */
/* @var $model CabUser */

$this->breadcrumbs=array(
	'Cab Users'=>array('index'),
	$model->id,
);

$this->menu=array(
	array('label'=>'List CabUser', 'url'=>array('index')),
	array('label'=>'Create CabUser', 'url'=>array('create')),
	array('label'=>'Update CabUser', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Delete CabUser', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Are you sure you want to delete this item?')),
	array('label'=>'Manage CabUser', 'url'=>array('admin')),
);
?>

<h1>View CabUser #<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'type_of_user',
		'fio',
		'organization',
		'email',
		'phone',
		'cab_state',
		'authorities_id',
		'user_roles_id',
		'str_tdata',
	),
)); ?>
