<?php
/* @var $this GenServCatConController */
/* @var $model GenServCatCon */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-serv-cat-con-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'categorie_id'); ?>
		<?php //echo $form->textField($model,'categorie_id'); ?>
		<?php echo $form->dropDownList($model, 'categorie_id', CHtml::listData(GenServCategories::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть категорію)')); ?>
		<?php echo $form->error($model,'categorie_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'service_id'); ?>
		<?php //echo $form->textField($model,'service_id'); ?>
		<?php echo $form->dropDownList($model, 'service_id', CHtml::listData(GenServices::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть послугу)')); ?>
		<?php echo $form->error($model,'service_id'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->