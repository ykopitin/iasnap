<?php
/* @var $this GenServCategoriesController */
/* @var $model GenServCategories */

$this->breadcrumbs=array(
	'Gen Serv Categories'=>array('index'),
	'Create',
);

$this->menu=array(
	array('label'=>'List GenServCategories', 'url'=>array('index')),
	array('label'=>'Manage GenServCategories', 'url'=>array('admin')),
);
?>

<h1>Create GenServCategories</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>