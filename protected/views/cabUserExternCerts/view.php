<?php
/* @var $this CabUserExternCertsController */
/* @var $model CabUserExternCerts */

$this->breadcrumbs=array(
	'Cab User Extern Certs'=>array('index'),
	$model->id,
);

$this->menu=array(
	array('label'=>'List CabUserExternCerts', 'url'=>array('index')),
	array('label'=>'Create CabUserExternCerts', 'url'=>array('create')),
	array('label'=>'Update CabUserExternCerts', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Delete CabUserExternCerts', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Are you sure you want to delete this item?')),
	array('label'=>'Manage CabUserExternCerts', 'url'=>array('admin')),
);
?>

<h1>View CabUserExternCerts #<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'type_of_user',
		'certissuer',
		'certserial',
		'certSubjDRFOCode',
		'certSubjEDRPOUCode',
		'certType',
		'certData',
		'ext_user_id',
	),
)); ?>
