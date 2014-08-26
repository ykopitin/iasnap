<?php
/* @var $this GenOtherInfoController */
/* @var $model GenOtherInfo */
/* @var $form CActiveForm */
?>
<script src="ckeditor/ckeditor.js"></script>
<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-other-info-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'publicationDate'); ?>
		<?php echo $form->textField($model,'publicationDate'); ?>
		<?php echo $form->error($model,'publicationDate'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'title'); ?>
		<?php echo $form->textField($model,'title',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'title'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'summary'); ?>
		<?php echo $form->textArea($model,'summary',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'summary'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'text'); ?>
		<?php echo $form->textArea($model,'text',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'text'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'img'); ?>
		<?php echo $form->textField($model,'img',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'img'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'kind_of_publication'); ?>
		<?php echo $form->dropDownList($model, 'kind_of_publication', CHtml::listData(GenMenuItems::model()->findAll(), 'id', 'content'),array('empty' => '(Оберіть вид публікації)')); ?>
		<?php echo $form->error($model,'kind_of_publication'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>
<script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace( 'GenOtherInfo[summary]' );
				CKEDITOR.replace( 'GenOtherInfo[text]' );
</script>
</div><!-- form -->