<?php
/* @var $this CabUserInternCertsController */
/* @var $model CabUserInternCerts */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління користувачами'=>array('default/id3'),
	'Таблиця «Сертифікати внутрішніх користувачів»'=>array('index'),
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

<h1>Оновити Таблиця «Сертифікати внутрішніх користувачів» запис № <?php echo $model->id; ?></h1>

<?php $this->renderPartial('_form', array('model'=>$model)); ?>

<h1>Неактивовані внутрішні користувачі</h1>

<?php 
$criteria=new CDbCriteria;
$criteria->compare('user_roles_id','<4',true);
$criteria->compare('str_activcode',$model->signedData,true);
$this->widget('zii.widgets.CListView', array(
	'dataProvider'=>new CActiveDataProvider('CabUser', array('criteria'=>$criteria)),
	'itemView'=>'application.modules.admin.views.cabUser._view',
)); ?>
