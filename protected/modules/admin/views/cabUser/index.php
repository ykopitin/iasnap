<?php
/* @var $this CabUserController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Cab Users',
);

$this->menu=array(
	array('label'=>'Create CabUser', 'url'=>array('create')),
	array('label'=>'Manage CabUser', 'url'=>array('admin')),
);
?>

<h1>Cab Users</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
