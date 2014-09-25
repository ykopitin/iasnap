<?php
/* @var $this CabUserExternalController */
/* @var $model CabUserExternal */

$this->breadcrumbs=array(
	'Cab User Externals'=>array('index'),
	$model->id,
);

$this->menu=array(
	array('label'=>'List CabUserExternal', 'url'=>array('index')),
	array('label'=>'Create CabUserExternal', 'url'=>array('create')),
	array('label'=>'Update CabUserExternal', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Delete CabUserExternal', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Are you sure you want to delete this item?')),
	array('label'=>'Manage CabUserExternal', 'url'=>array('admin')),
);
?>

<h1>View CabUserExternal #<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'type_of_user',
		'email',
		'phone',
		'cab_state',
	),
)); ?>
