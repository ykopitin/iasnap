<?php
/* @var $this GenServCategoriesController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Gen Serv Categories',
);

$this->menu=array(
	array('label'=>'Create GenServCategories', 'url'=>array('create')),
	array('label'=>'Manage GenServCategories', 'url'=>array('admin')),
);
?>

<h1>Gen Serv Categories</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
