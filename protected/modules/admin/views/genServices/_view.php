<?php
/* @var $this GenServicesController */
/* @var $model GenServices */
/* @var $form CActiveForm */
?>

<div class="form">



	<b><?php echo CHtml::encode($model->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::encode($model->id); ?>
	<br />
	
	<b><?php echo CHtml::encode($model->getAttributeLabel('name')); ?>:</b>
	<?php echo CHtml::encode($model->name); ?>
	<br />
	
	<b><?php echo CHtml::encode('Відомості про місце подачі'); ?>:</b>
	<?php //echo CHtml::encode($model->subjnap_id); ?>
	<?php echo CHtml::encode(GenAuthorities::model()->find('id=:id', array(':id'=>$model->subjnap_id))->name); ?>
	<br />

	<b><?php echo CHtml::encode('Відомості про виконавця'); ?>:</b>
	<?php //echo CHtml::encode($model->subjnap_id); ?>
	<?php echo CHtml::encode(GenAuthorities::model()->find('id=:id', array(':id'=>$model->subjwork_id))->name); ?>
	<br />
		
	<b><?php echo CHtml::encode($model->getAttributeLabel('regulations')); ?>:</b>
	<?php echo CHtml::encode($model->regulations); ?>
	<br />
    	
	<b><?php echo CHtml::encode($model->getAttributeLabel('submission_proc')); ?>:</b>
	<?php echo CHtml::encode($model->submission_proc); ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('docums')); ?>:</b>
	<?php echo CHtml::encode($model->docums); ?>
	<br />
    
	<b><?php echo CHtml::encode($model->getAttributeLabel('is_payed')); ?>:</b>
	<?php if($model->is_payed==0) {echo "ні";}else {echo "так";} ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('payed_regulations')); ?>:</b>
	<?php echo CHtml::encode($model->payed_regulations); ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('payed_rate')); ?>:</b>
	<?php echo CHtml::encode($model->payed_rate); ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('bank_info')); ?>:</b>
	<?php echo CHtml::encode($model->bank_info); ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('deadline')); ?>:</b>
	<?php echo CHtml::encode($model->deadline); ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('denail_grounds')); ?>:</b>
	<?php echo CHtml::encode($model->denail_grounds); ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('result')); ?>:</b>
	<?php echo CHtml::encode($model->result); ?>
	<br />

	<b><?php echo CHtml::encode($model->getAttributeLabel('answer')); ?>:</b>
	<?php echo CHtml::encode($model->answer); ?>
	<br />
    
	<b><?php echo CHtml::encode($model->getAttributeLabel('is_online')); ?>:</b>
	<?php echo CHtml::encode($model->is_online); ?>
	<br />
	

</div><!-- form -->