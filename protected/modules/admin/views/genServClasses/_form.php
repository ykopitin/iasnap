<?php
/* @var $this GenServClassesController */
/* @var $model GenServClasses */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-serv-classes-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'item_name'); ?>
		<?php echo $form->textField($model,'item_name',array('size'=>45,'maxlength'=>45)); ?>
		<?php echo $form->error($model,'item_name'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'visability'); ?>
		<?php // echo $form->textField($model,'visability',array('size'=>6,'maxlength'=>6)); ?>
		<?php echo $form->DropDownList( $model,'visability', ZHtml::enumItem($model,'visability'),array('empty' => '(Оберіть видимість)')); ?>
		<?php echo $form->error($model,'visability'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->