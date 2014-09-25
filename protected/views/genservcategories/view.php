<?php
/* @var $this GenServCategoriesController */
/* @var $model GenServCategories */

$this->breadcrumbs=array(
	'Gen Serv Categories'=>array('index'),
	$model->name,
);

$this->menu=array(
	array('label'=>'List GenServCategories', 'url'=>array('index')),
	array('label'=>'Create GenServCategories', 'url'=>array('create')),
	array('label'=>'Update GenServCategories', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Delete GenServCategories', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Are you sure you want to delete this item?')),
	array('label'=>'Manage GenServCategories', 'url'=>array('admin')),
);
?>

<h1>View GenServCategories #<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'name',
		'visability',
	),
)); ?>
