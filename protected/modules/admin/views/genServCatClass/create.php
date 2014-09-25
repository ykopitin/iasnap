<?php
/* @var $this GenServCatClassController */
/* @var $model GenServCatClass */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління послугами'=>array('default/id2'),
	'Таблиця «Зв\'язок послуг з категоріями та класами»'=>array('index'),
	'Додавання',
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Додати дані Таблиця «Зв'язок послуг з категоріями та класами»</h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>