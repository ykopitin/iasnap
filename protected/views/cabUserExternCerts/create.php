<?php
/* @var $this CabUserExternCertsController */
/* @var $model CabUserExternCerts */

$this->breadcrumbs=array(
	'Cab User Extern Certs'=>array('index'),
	'Create',
);

$this->menu=array(
	array('label'=>'List CabUserExternCerts', 'url'=>array('index')),
	array('label'=>'Manage CabUserExternCerts', 'url'=>array('admin')),
);
?>

<h1>Create CabUserExternCerts</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>