<?php
/* @var $this CabUserInternalController */
/* @var $model CabUserInternal */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'cab-user-internal-form',
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
		<?php echo $form->textField($model,'id'); ?>
		<?php echo $form->error($model,'id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'authorities_id'); ?>
		<?php echo $form->textField($model,'authorities_id'); ?>
		<?php echo $form->error($model,'authorities_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'user_roles_id'); ?>
		<?php echo $form->textField($model,'user_roles_id'); ?>
		<?php echo $form->error($model,'user_roles_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'cab_state'); ?>
		<?php echo $form->textField($model,'cab_state',array('size'=>22,'maxlength'=>22)); ?>
		<?php echo $form->error($model,'cab_state'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->