<?php
/* @var $this GenRegulationsController */
/* @var $model GenRegulations */
/* @var $form CActiveForm */
?>
<?php
$baseUrl = Yii::app()->baseUrl;
//echo $baseUrl;
$cs = Yii::app()->getClientScript();
$cs->registerScriptFile($baseUrl.'/ckeditor/ckeditor.js');
$cs->registerScriptFile($baseUrl.'/js/jquery.js');
$cs->registerScriptFile($baseUrl.'/js/ShowHide.js');
?>
<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-regulations-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'type'); ?>
		<?php echo $form->DropDownList( $model,'type', ZHtml::enumItem($model,'type'),array('empty' => '(Оберіть тип)')); ?>
		<?php echo $form->error($model,'type'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'name'); ?>
		<?php //echo $form->textField($model,'name',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->textArea($model,'name',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'name'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'hyperlink'); ?>
		<?php //echo $form->textField($model,'hyperlink',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->textArea($model,'hyperlink',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'hyperlink'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->
<script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
				CKEDITOR.replace( 'GenRegulations[name]' );
                CKEDITOR.replace( 'GenRegulations[hyperlink]' );
</script>