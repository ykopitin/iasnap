<?php
/* @var $this GenServLifeSituationsController */
/* @var $model GenServLifeSituations */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-serv-life-situations-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php //echo $form->labelEx($model,'id'); ?>
		<?php //echo $form->textField($model,'id'); ?>
		<?php //echo $form->error($model,'id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'service_id'); ?>
		<?php //echo $form->textField($model,'service_id'); ?>
		<?php echo $form->dropDownList($model, 'service_id', CHtml::listData(GenServices::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть послугу)','style'=>'max-width:650px')); ?>
		<?php echo $form->error($model,'service_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'life_situation_id'); ?>
		<?php //echo $form->textField($model,'life_situation_id'); ?>
		<?php echo $form->dropDownList($model, 'life_situation_id', CHtml::listData(GenLifeSituation::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть життєву ситуацію)','style'=>'max-width:650px')); ?>
		<?php echo $form->error($model,'life_situation_id'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->