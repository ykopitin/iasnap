<?php
/* @var $this GenAuthoritiesController */
/* @var $model GenAuthorities */
/* @var $form CActiveForm */
?>
<script src="ckeditor/ckeditor.js"></script>
<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-authorities-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'is_cnap'); ?>
		<?php //echo $form->textField($model,'is_cnap',array('size'=>8,'maxlength'=>8)); ?>
		<?php echo $form->DropDownList( $model,'is_cnap', ZHtml::enumItem($model,'is_cnap'),array('empty' => '(Оберіть тип)')); ?>
		<?php echo $form->error($model,'is_cnap'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'type'); ?>
		<?php //echo $form->textField($model,'type',array('size'=>16,'maxlength'=>16)); ?>
		<?php echo $form->DropDownList( $model,'type', ZHtml::enumItem($model,'type'),array('empty' => '(Оберіть приналежність)')); ?>
		<?php echo $form->error($model,'type'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'name'); ?>
		<?php echo $form->textField($model,'name',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'name'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'locations_id'); ?>
		<?php //echo $form->textField($model,'locations_id'); ?>
		<?php echo $form->dropDownList($model, 'locations_id', CHtml::listData(GenLocations::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть населений пункт)')); ?>
		<?php echo $form->error($model,'locations_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'index'); ?>
		<?php echo $form->textField($model,'index',array('size'=>5,'maxlength'=>5)); ?>
		<?php echo $form->error($model,'index'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'street'); ?>
		<?php echo $form->textField($model,'street',array('size'=>50,'maxlength'=>50)); ?>
		<?php echo $form->error($model,'street'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'building'); ?>
		<?php echo $form->textField($model,'building',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'building'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'office'); ?>
		<?php echo $form->textField($model,'office',array('size'=>5,'maxlength'=>5)); ?>
		<?php echo $form->error($model,'office'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'working_time'); ?>
		<?php //echo $form->textField($model,'working_time',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->textArea($model,'working_time',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'working_time'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'phone'); ?>
		<?php echo $form->textField($model,'phone',array('size'=>44,'maxlength'=>44)); ?>
		<?php echo $form->error($model,'phone'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'fax'); ?>
		<?php echo $form->textField($model,'fax',array('size'=>29,'maxlength'=>29)); ?>
		<?php echo $form->error($model,'fax'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'email'); ?>
		<?php echo $form->textField($model,'email',array('size'=>45,'maxlength'=>45)); ?>
		<?php echo $form->error($model,'email'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'web'); ?>
		<?php echo $form->textField($model,'web',array('size'=>45,'maxlength'=>45)); ?>
		<?php echo $form->error($model,'web'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'transport'); ?>
		<?php echo $form->textField($model,'transport',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'transport'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'gpscoordinates'); ?>
		<?php echo $form->textField($model,'gpscoordinates',array('size'=>20,'maxlength'=>20)); ?>
		<?php echo $form->error($model,'gpscoordinates'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'photo'); ?>
		<?php echo $form->textField($model,'photo',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'photo'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>
<script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace( 'GenAuthorities[working_time]' );
</script>
</div><!-- form -->