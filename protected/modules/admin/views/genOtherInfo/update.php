<?php
/* @var $this GenOtherInfoController */
/* @var $model GenOtherInfo */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління загальним інтерфейсом порталу'=>array('default/id1'),
	'Таблиця «Посилання на статті до категорій сайту»'=>array('index'),
	$model->title=>array('view','id'=>$model->id),
	'Оновлення',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Показати', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Оновити Таблиця «Посилання на статті до категорій сайту» запис № <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>