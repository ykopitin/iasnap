<?php
/* @var $this GenNewsController */
/* @var $model GenNews */
/* @var $form CActiveForm */
?>


<?php
$baseUrl = Yii::app()->baseUrl;
$cs = Yii::app()->getClientScript();
$cs->registerScriptFile($baseUrl.'/ckeditor/ckeditor.js');
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-news-form',
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
		<?php //echo $form->textField($model,'publicationDate'); ?>
		<?php $this->widget('zii.widgets.jui.CJuiDatePicker', array(
        'name' => 'publicationDate',
        'model' => $model,
        'attribute' => 'publicationDate',
        'language' => 'ru',
        'options' => array(
         'showAnim' => 'fold',
        ),
         'htmlOptions' => array(
         'style' => 'height:20px;'
        ),
        ));?>
		<?php echo $form->error($model,'publicationDate'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'title'); ?>
		<?php //echo $form->textField($model,'title',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->textArea($model,'title',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'title'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'summary'); ?>
		<?php echo $form->textArea($model,'summary',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'summary'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'text'); ?>
		<?php echo $form->textArea($model,'text',array('id'=>"editor1",'rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'text'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'img'); ?>
		<?php echo $form->textArea($model,'img',array('rows'=>6, 'cols'=>50)); ?>
		<?php //echo $form->textField($model,'img',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'img'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>
<script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace( 'GenNews[title]' );
				CKEDITOR.replace( 'GenNews[summary]' );
				CKEDITOR.replace( 'GenNews[text]' );
				CKEDITOR.replace( 'GenNews[img]' );
</script>
</div><!-- form -->