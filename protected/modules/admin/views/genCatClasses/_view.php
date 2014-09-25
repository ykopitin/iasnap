<?php
/* @var $this GenCatClassesController */
/* @var $data GenCatClasses */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode("Категорія послуги"); ?>:</b>
	<?php echo CHtml::encode(GenServCategories::model()->findByPk($data->categorie_id)->name); ?>
	<br />

	<b><?php echo CHtml::encode("Клас послуги"); ?>:</b>
	<?php echo CHtml::encode(GenServClasses::model()->findByPK($data->class_id)->item_name); ?>
	<br />


</div>