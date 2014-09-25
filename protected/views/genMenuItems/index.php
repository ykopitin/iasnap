<?php
/* @var $this GenMenuItemsController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Gen Menu Items',
);

$this->menu=array(
	array('label'=>'Create GenMenuItems', 'url'=>array('create')),
	array('label'=>'Manage GenMenuItems', 'url'=>array('admin')),
);
?>

<h1>Gen Menu Items</h1>
пумпидум
<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
