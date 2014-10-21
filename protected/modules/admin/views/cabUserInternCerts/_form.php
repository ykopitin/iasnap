<?php
/* @var $this CabUserInternCertsController */
/* @var $model CabUserInternCerts */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'cab-user-intern-certs-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'id'); ?>
		<?php echo $form->textField($model,'id',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certissuer'); ?>
		<?php echo $form->textArea($model,'certissuer',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certissuer'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certserial'); ?>
		<?php echo $form->textField($model,'certserial',array('size'=>40,'maxlength'=>40)); ?>
		<?php echo $form->error($model,'certserial'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjDRFOCode'); ?>
		<?php echo $form->textField($model,'certSubjDRFOCode',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'certSubjDRFOCode'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjEDRPOUCode'); ?>
		<?php echo $form->textField($model,'certSubjEDRPOUCode',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'certSubjEDRPOUCode'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certType'); ?>
		<?php echo $form->textField($model,'certType'); ?>
		<?php echo $form->error($model,'certType'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'signedData'); ?>
		<?php echo $form->textField($model,'signedData',array('size'=>40,'maxlength'=>40)); ?>
		<?php echo $form->error($model,'signedData'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'new_user'); ?>
		<?php //echo $form->textField($model,'authorities_id'); ?>
		<?php echo $form->dropDownList($model, 'new_user', CHtml::listData(CabUser::model()->findAll(array(
			'condition'=>'user_roles_id < 4 AND cab_state = "не активований"')), 'id', 'id'),
			array('empty' => "Прив'язати сертифікат до користувача")); ?>
		<?php echo $form->error($model,'new_user'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->
