<?php
/* @var $this GenServCatConController */
/* @var $data GenServCatCon */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('categorie_id')); ?>:</b>
	<?php echo CHtml::encode(GenServCategories::model()->findByPk($data->categorie_id)->name); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('service_id')); ?>:</b>
	<?php echo CHtml::encode(GenServices::model()->findByPk($data->service_id)->name); ?>
	<br />


</div>