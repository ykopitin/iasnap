<?php
/* @var $this GenServicesController */
/* @var $model GenServices */
/* @var $form CActiveForm */
?>

<div class="wide form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'action'=>Yii::app()->createUrl($this->route),
	'method'=>'get',
)); ?>

	<div class="row">
		<?php echo $form->label($model,'id'); ?>
		<?php echo $form->textField($model,'id'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'name'); ?>
		<?php echo $form->textField($model,'name',array('size'=>60,'maxlength'=>255)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'subjnap_id'); ?>
		<?php echo $form->textField($model,'subjnap_id'); ?>
	</div>
	
	<div class="row">
		<?php echo $form->label($model,'subjwork_id'); ?>
		<?php echo $form->textField($model,'subjwork_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'regulations'); ?>
		<?php echo $form->textArea($model,'regulations',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'reason'); ?>
		<?php echo $form->textArea($model,'reason',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'submission_proc'); ?>
		<?php echo $form->textArea($model,'submission_proc',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'docums'); ?>
		<?php echo $form->textArea($model,'docums',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'is_payed'); ?>
		<?php echo $form->textField($model,'is_payed'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'payed_regulations'); ?>
		<?php echo $form->textArea($model,'payed_regulations',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'payed_rate'); ?>
		<?php echo $form->textArea($model,'payed_rate',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'bank_info'); ?>
		<?php echo $form->textArea($model,'bank_info',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'deadline'); ?>
		<?php echo $form->textArea($model,'deadline',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'denail_grounds'); ?>
		<?php echo $form->textArea($model,'denail_grounds',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'result'); ?>
		<?php echo $form->textArea($model,'result',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'answer'); ?>
		<?php echo $form->textArea($model,'answer',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'is_online'); ?>
		<?php echo $form->textField($model,'is_online',array('size'=>6,'maxlength'=>6)); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton('Search'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- search-form -->