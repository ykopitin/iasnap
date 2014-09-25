<?php
/* @var $this GenServicesController */
/* @var $data GenServices */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('name')); ?>:</b>
	<?php echo CHtml::encode($data->name); ?>
	<br />

	<b><?php echo CHtml::encode('Відомості про місце подачі'); ?>:</b>
	<?php //echo CHtml::encode($data->subjnap_id); ?>
	<?php echo CHtml::encode(GenAuthorities::model()->find('id=:id', array(':id'=>$data->subjnap_id))->name); ?>
	<br />

	<b><?php echo CHtml::encode('Відомості про виконавця'); ?>:</b>
	<?php //echo CHtml::encode($data->subjnap_id); ?>
	<?php echo CHtml::encode(GenAuthorities::model()->find('id=:id', array(':id'=>$data->subjwork_id))->name); ?>
	<br />
	
	<b><?php echo CHtml::encode($data->getAttributeLabel('regulations')); ?>:</b>
	<?php echo CHtml::encode($data->regulations); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('reason')); ?>:</b>
	<?php echo CHtml::encode($data->reason); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('submission_proc')); ?>:</b>
	<?php echo CHtml::encode($data->submission_proc); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('docums')); ?>:</b>
	<?php echo CHtml::encode($data->docums); ?>
	<br />

	<?php /*
	<b><?php echo CHtml::encode($data->getAttributeLabel('is_payed')); ?>:</b>
	<?php echo CHtml::encode($data->is_payed); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('payed_regulations')); ?>:</b>
	<?php echo CHtml::encode($data->payed_regulations); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('payed_rate')); ?>:</b>
	<?php echo CHtml::encode($data->payed_rate); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('bank_info')); ?>:</b>
	<?php echo CHtml::encode($data->bank_info); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('deadline')); ?>:</b>
	<?php echo CHtml::encode($data->deadline); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('denail_grounds')); ?>:</b>
	<?php echo CHtml::encode($data->denail_grounds); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('result')); ?>:</b>
	<?php echo CHtml::encode($data->result); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('answer')); ?>:</b>
	<?php echo CHtml::encode($data->answer); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('is_online')); ?>:</b>
	<?php echo CHtml::encode($data->is_online); ?>
	<br />

	*/ ?>

</div>