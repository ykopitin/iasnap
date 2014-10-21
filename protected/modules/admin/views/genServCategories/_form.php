<?php
/* @var $this GenServCategoriesController */
/* @var $model GenServCategories */
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
	'id'=>'gen-serv-categories-form',
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
		<?php echo $form->textField($model,'name',array('size'=>60,'maxlength'=>60)); ?>
		<?php echo $form->error($model,'name'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'visability'); ?>
		<?php // echo $form->textField($model,'visability',array('size'=>6,'maxlength'=>6)); ?>
		<?php echo $form->DropDownList( $model,'visability', ZHtml::enumItem($model,'visability'),array('empty' => '(Оберіть видимість)')); ?>
		<?php echo $form->error($model,'visability'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'icon'); ?>
		<?php //echo $form->textField($model,'icon',array('size'=>60,'maxlength'=>60)); ?>
		<?php echo $form->textArea($model,'icon',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'icon'); ?>
	</div>	
	
	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->
<script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
				CKEDITOR.replace( 'GenServCategories[icon]' );
</script>