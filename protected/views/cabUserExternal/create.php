<?php
/* @var $this CabUserExternalController */
/* @var $model CabUserExternal */

$this->breadcrumbs=array(
	'Cab User Externals'=>array('index'),
	'Create',
);

$this->menu=array(
	array('label'=>'List CabUserExternal', 'url'=>array('index')),
	array('label'=>'Manage CabUserExternal', 'url'=>array('admin')),
);
?>

<h1>Create CabUserExternal</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>