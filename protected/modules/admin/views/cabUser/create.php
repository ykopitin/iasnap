<?php
/* @var $this CabUserController */
/* @var $model CabUser */

$this->breadcrumbs=array(
	'Cab Users'=>array('index'),
	'Create',
);

$this->menu=array(
	array('label'=>'List CabUser', 'url'=>array('index')),
	array('label'=>'Manage CabUser', 'url'=>array('admin')),
);
?>

<h1>Create CabUser</h1>

<?php 
	$model->str_activcode = sprintf("%08d", rand(0,99999999));
	$this->renderPartial('_form', array('model'=>$model));
?>
