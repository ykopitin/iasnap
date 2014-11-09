<?php
/* @var $this CabUserExternCertsController */
/* @var $model CabUserExternCerts */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління довідниками'=>array('default/id4'),
	'Таблиця «Сертифікати зовнішніх користувачів»'=>array('index'),
	$model->id,
);

$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Додати', 'url'=>array('create')),
	array('label'=>'Оновити', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Вилучити', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Ви впевнені, що бажаєти вилучити дані?')),
	array('label'=>'Управляти', 'url'=>array('admin')),
);
?>

<h1>Відобразити Таблиця «Сертифікати зовнішніх користувачів» запис №<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'type_of_user',
		'certissuer',
		'certserial',
		'certSubjDRFOCode',
		'certSubjEDRPOUCode',
		'certData',
		'certType',
		'ext_user_id',
		'certSignTime',
		'certUseTSP',
		'certIssuerCN',
		'certSubject',
		'certSubjCN',
		'certSubjOrg',
		'certSubjOrgUnit',
		'certSubjTitle',
		'certSubjState',
		'certSubjLocality',
		'certSubjFullName',
		'certSubjAddress',
		'certSubjPhone',
		'certSubjEMail',
		'certSubjDNS',
		array(
			'name'=>'certExpireBeginTime',
			'value'=>date("d.m.Y h:i:s", $model->certExpireBeginTime),
		),
		array(
			'name'=>'certExpireEndTime',
			'value'=>date("d.m.Y h:i:s", $model->certExpireEndTime),
		),
//		'certExpireEndTime',
		),
)); ?>
