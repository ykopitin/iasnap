<?php
/* @var $this GenMenuItemsController */
/* @var $model GenMenuItems */

$this->breadcrumbs=array(
	'Gen Menu Items'=>array('index'),
	$model->id=>array('view','id'=>$model->id),
	'Update',
);

$this->menu=array(
	array('label'=>'List GenMenuItems', 'url'=>array('index')),
	array('label'=>'Create GenMenuItems', 'url'=>array('create')),
	array('label'=>'View GenMenuItems', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Manage GenMenuItems', 'url'=>array('admin')),
);
?>

<h1>Update GenMenuItems <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>