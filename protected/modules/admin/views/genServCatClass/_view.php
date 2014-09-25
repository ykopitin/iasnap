<?php
/* @var $this GenServCatClassController */
/* @var $data GenServCatClass */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode("Назва послуги"); ?>:</b>
	<?php echo CHtml::encode(GenServices::model()->findByPk($data->service_id)->name); ?>
	<br />

	<b><?php echo CHtml::encode("Клас/Категорія"); ?>:</b>
	<?php $i=GenServCategories::model()->findByPk(GenCatClasses::model()->findByPk($data->cat_class_id)->categorie_id)->name;
	$ii=GenServClasses::model()->findByPk(GenCatClasses::model()->findByPk($data->cat_class_id)->class_id)->item_name;
	echo CHtml::encode($ii."  / ".$i); ?>
	<br />


</div>