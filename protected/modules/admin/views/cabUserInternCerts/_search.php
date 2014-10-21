<?php
/* @var $this CabUserInternCertsController */
/* @var $model CabUserInternCerts */
/* @var $form CActiveForm */
?>

<div class="wide form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'action'=>Yii::app()->createUrl($this->route),
	'method'=>'get',
)); ?>

	<div class="row">
		<?php echo $form->label($model,'id'); ?>
		<?php echo $form->textField($model,'id',array('size'=>10,'maxlength'=>10)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certissuer'); ?>
		<?php echo $form->textArea($model,'certissuer',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certserial'); ?>
		<?php echo $form->textField($model,'certserial',array('size'=>40,'maxlength'=>40)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjDRFOCode'); ?>
		<?php echo $form->textField($model,'certSubjDRFOCode',array('size'=>10,'maxlength'=>10)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjEDRPOUCode'); ?>
		<?php echo $form->textField($model,'certSubjEDRPOUCode',array('size'=>10,'maxlength'=>10)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certData'); ?>
		<?php echo $form->textField($model,'certData'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certType'); ?>
		<?php echo $form->textField($model,'certType'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'signedData'); ?>
		<?php echo $form->textField($model,'signedData',array('size'=>40,'maxlength'=>40)); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton('Search'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- search-form -->