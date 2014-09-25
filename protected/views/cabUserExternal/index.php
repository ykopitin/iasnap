<?php
/* @var $this CabUserExternalController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Cab User Externals',
);

$this->menu=array(
	array('label'=>'Create CabUserExternal', 'url'=>array('create')),
	array('label'=>'Manage CabUserExternal', 'url'=>array('admin')),
);
?>

<h1>Cab User Externals</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
