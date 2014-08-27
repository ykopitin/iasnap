<?php
/* @var $this GenServicesController */
/* @var $model GenServices */
/* @var $form CActiveForm */
?>
<script src="ckeditor/ckeditor.js"></script>
<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-services-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'name'); ?>
		<?php echo $form->textField($model,'name',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'name'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'subjnap_id'); ?>
		<?php //echo $form->textField($model,'subjnap_id'); ?>
		<?php echo $form->dropDownList($model, 'subjnap_id', CHtml::listData(GenAuthorities::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть суб\'єкта надання)')); ?>
		<?php echo $form->error($model,'subjnap_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'regulations'); ?>
		<?php echo $form->textArea($model,'regulations',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'regulations'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'reason'); ?>
		<?php echo $form->textArea($model,'reason',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'reason'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'submission_proc'); ?>
		<?php echo $form->textArea($model,'submission_proc',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'submission_proc'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'docums'); ?>
		<?php echo $form->textArea($model,'docums',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'docums'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'is_payed'); ?>
		<?php echo $form->textField($model,'is_payed'); ?>
		<?php echo $form->error($model,'is_payed'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'payed_regulations'); ?>
		<?php echo $form->textArea($model,'payed_regulations',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'payed_regulations'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'payed_rate'); ?>
		<?php echo $form->textArea($model,'payed_rate',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'payed_rate'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'bank_info'); ?>
		<?php echo $form->textArea($model,'bank_info',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'bank_info'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'deadline'); ?>
		<?php echo $form->textArea($model,'deadline',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'deadline'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'denail_grounds'); ?>
		<?php echo $form->textArea($model,'denail_grounds',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'denail_grounds'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'result'); ?>
		<?php echo $form->textArea($model,'result',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'result'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'answer'); ?>
		<?php echo $form->textArea($model,'answer',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'answer'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'is_online'); ?>
		<?php //echo $form->textField($model,'is_online',array('size'=>6,'maxlength'=>6)); ?>
		<?php echo $form->DropDownList( $model,'is_online', ZHtml::enumItem($model,'is_online'),array('empty' => '(Оберіть режим надання)')); ?>
		<?php echo $form->error($model,'is_online'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>
<script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace( 'GenServices[regulations]' );
				CKEDITOR.replace( 'GenServices[docums]' );
				CKEDITOR.replace( 'GenServices[reason]' );
				CKEDITOR.replace( 'GenServices[submission_proc]' );				
                CKEDITOR.replace( 'GenServices[payed_regulations]' );
				CKEDITOR.replace( 'GenServices[payed_rate]' );
				CKEDITOR.replace( 'GenServices[bank_info]' );
				CKEDITOR.replace( 'GenServices[deadline]' );
				CKEDITOR.replace( 'GenServices[denail_grounds]' );
				CKEDITOR.replace( 'GenServices[result]' );
				CKEDITOR.replace('GenServices[answer]'  );
</script>
</div><!-- form -->