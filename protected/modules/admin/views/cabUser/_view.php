<?php
/* @var $this CabUserController */
/* @var $data CabUser */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('type_of_user')); ?>:</b>
	<?php echo CHtml::encode($data->type_of_user); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('fio')); ?>:</b>
	<?php echo CHtml::encode($data->fio); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('organization')); ?>:</b>
	<?php echo CHtml::encode($data->organization); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('email')); ?>:</b>
	<?php echo CHtml::encode($data->email); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('phone')); ?>:</b>
	<?php echo CHtml::encode($data->phone); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('cab_state')); ?>:</b>
	<?php echo CHtml::encode($data->cab_state); ?>
	<br />

	<?php /*
	<b><?php echo CHtml::encode($data->getAttributeLabel('authorities_id')); ?>:</b>
	<?php echo CHtml::encode($data->authorities_id); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('user_roles_id')); ?>:</b>
	<?php echo CHtml::encode($data->user_roles_id); ?>
	<br />

	*/ ?>

	<b><?php echo CHtml::encode($data->getAttributeLabel('str_tdata')); ?>:</b>
	<?php echo CHtml::encode($data->str_tdata); ?>
	<br />

</div>
