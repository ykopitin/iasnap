<?php
/* @var $this CabUserExternCertsController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Cab User Extern Certs',
);

$this->menu=array(
	array('label'=>'Create CabUserExternCerts', 'url'=>array('create')),
	array('label'=>'Manage CabUserExternCerts', 'url'=>array('admin')),
);
?>

<h1>Cab User Extern Certs</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
