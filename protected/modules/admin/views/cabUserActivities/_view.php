<?php
/* @var $this CabUserActivitiesController */
/* @var $data CabUserActivities */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('portal_user_id')); ?>:</b>
	<?php echo CHtml::encode($data->portal_user_id); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('visiting')); ?>:</b>
	<?php echo CHtml::encode($data->visiting); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('IPAdress')); ?>:</b>
	<?php echo CHtml::encode($data->IPAdress); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('type')); ?>:</b>
	<?php echo CHtml::encode($data->type); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('success')); ?>:</b>
	<?php echo CHtml::encode($data->success); ?>
	<br />


</div>