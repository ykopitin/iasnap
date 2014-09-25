<?php
/* @var $this CabUserInternCertsController */
/* @var $data CabUserInternCerts */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certissuer')); ?>:</b>
	<?php echo CHtml::encode($data->certissuer); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certserial')); ?>:</b>
	<?php echo CHtml::encode($data->certserial); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjDRFOCode')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjDRFOCode); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjEDRPOUCode')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjEDRPOUCode); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certData')); ?>:</b>
	<?php echo CHtml::encode($data->certData); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('type')); ?>:</b>
	<?php echo CHtml::encode($data->type); ?>
	<br />

	<?php /*
	<b><?php echo CHtml::encode($data->getAttributeLabel('int_user_id')); ?>:</b>
	<?php echo CHtml::encode($data->int_user_id); ?>
	<br />

	*/ ?>

</div>