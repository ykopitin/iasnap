<?php
/* @var $this CabUserInternalController */
/* @var $data CabUserInternal */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('authorities_id')); ?>:</b>
	<?php echo CHtml::encode($data->authorities_id); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('user_roles_id')); ?>:</b>
	<?php echo CHtml::encode($data->user_roles_id); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('cab_state')); ?>:</b>
	<?php echo CHtml::encode($data->cab_state); ?>
	<br />


</div>