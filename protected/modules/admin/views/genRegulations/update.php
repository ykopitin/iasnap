<?php
/* @var $this GenRegulationsController */
/* @var $model GenRegulations */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління загальним інтерфейсом порталу'=>array('default/id1'),
	'Таблиця «Відомості про нормативно-правові акти»'=>array('index'),
	$model->name=>array('view','id'=>$model->id),
	'Оновлення',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Показати', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Оновити Таблиця «Відомості про нормативно-правові акти» запис № <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>