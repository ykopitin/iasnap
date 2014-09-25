<?php
/* @var $this CabUserExternalController */
/* @var $model CabUserExternal */

$this->breadcrumbs=array(
	'Cab User Externals'=>array('index'),
	$model->id=>array('view','id'=>$model->id),
	'Update',
);

$this->menu=array(
	array('label'=>'List CabUserExternal', 'url'=>array('index')),
	array('label'=>'Create CabUserExternal', 'url'=>array('create')),
	array('label'=>'View CabUserExternal', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Manage CabUserExternal', 'url'=>array('admin')),
);
?>

<h1>Update CabUserExternal <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>