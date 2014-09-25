<?php
/* @var $this CabUserActivitiesController */
/* @var $model CabUserActivities */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'cab-user-activities-form',
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
		<?php echo $form->labelEx($model,'portal_user_id'); ?>
		<?php echo $form->textField($model,'portal_user_id'); ?>
		<?php echo $form->error($model,'portal_user_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'visiting'); ?>
		<?php echo $form->textField($model,'visiting'); ?>
		<?php echo $form->error($model,'visiting'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'IPAdress'); ?>
		<?php echo $form->textField($model,'IPAdress',array('size'=>15,'maxlength'=>15)); ?>
		<?php echo $form->error($model,'IPAdress'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'type'); ?>
		<?php echo $form->textField($model,'type',array('size'=>26,'maxlength'=>26)); ?>
		<?php echo $form->error($model,'type'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'success'); ?>
		<?php echo $form->textField($model,'success'); ?>
		<?php echo $form->error($model,'success'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->