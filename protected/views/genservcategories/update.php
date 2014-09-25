<?php
/* @var $this GenServCategoriesController */
/* @var $model GenServCategories */

$this->breadcrumbs=array(
	'Gen Serv Categories'=>array('index'),
	$model->name=>array('view','id'=>$model->id),
	'Update',
);

$this->menu=array(
	array('label'=>'List GenServCategories', 'url'=>array('index')),
	array('label'=>'Create GenServCategories', 'url'=>array('create')),
	array('label'=>'View GenServCategories', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Manage GenServCategories', 'url'=>array('admin')),
);
?>

<h1>Update GenServCategories <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>