<?php
/* @var $this CabUserController */
/* @var $model CabUser */

$this->breadcrumbs=array(
	'Cab Users'=>array('index'),
	$model->id=>array('view','id'=>$model->id),
	'Update',
);

$this->menu=array(
	array('label'=>'List CabUser', 'url'=>array('index')),
	array('label'=>'Create CabUser', 'url'=>array('create')),
	array('label'=>'View CabUser', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Manage CabUser', 'url'=>array('admin')),
);
?>

<h1>Update CabUser <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>