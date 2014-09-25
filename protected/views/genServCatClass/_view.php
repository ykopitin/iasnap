<?php
/* @var $this GenServCatClassController */
/* @var $data GenServCatClass */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('service_id')); ?>:</b>
	<?php echo CHtml::encode($data->service_id); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('cat_class_id')); ?>:</b>
	<?php echo CHtml::encode($data->cat_class_id); ?>
	<br />


</div>