<?php
/* @var $this CabUserExternalController */
/* @var $model CabUserExternal */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління користувачами'=>array('default/id3'),
	'Таблиця «Каталог зовнішніх користувачів порталу»'=>array('index'),
	$model->id=>array('view','id'=>$model->id),
	'Оновлення',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Показати', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Оновити Таблиця «Каталог зовнішніх користувачів порталу» запис № <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>