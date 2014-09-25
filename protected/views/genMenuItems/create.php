<?php
/* @var $this GenMenuItemsController */
/* @var $model GenMenuItems */

$this->breadcrumbs=array(
	'Gen Menu Items'=>array('index'),
	'Create',
);

$this->menu=array(
	array('label'=>'List GenMenuItems', 'url'=>array('index')),
	array('label'=>'Manage GenMenuItems', 'url'=>array('admin')),
);
?>

<h1>Create GenMenuItems</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>