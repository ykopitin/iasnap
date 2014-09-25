<?php
/* @var $this CabUserExternCertsController */
/* @var $model CabUserExternCerts */

$this->breadcrumbs=array(
	'Cab User Extern Certs'=>array('index'),
	$model->id=>array('view','id'=>$model->id),
	'Update',
);

$this->menu=array(
	array('label'=>'List CabUserExternCerts', 'url'=>array('index')),
	array('label'=>'Create CabUserExternCerts', 'url'=>array('create')),
	array('label'=>'View CabUserExternCerts', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Manage CabUserExternCerts', 'url'=>array('admin')),
);
?>

<h1>Update CabUserExternCerts <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>