<?php
/* @var $this GenLifeSituationController */
/* @var $model GenLifeSituation */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-life-situation-form',
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
		<?php echo $form->textField($model,'name',array('size'=>60,'maxlength'=>100)); ?>
		<?php echo $form->error($model,'name'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'visability'); ?>
		<?php //echo $form->textField($model,'visability',array('size'=>6,'maxlength'=>6)); ?>
		<?php echo $form->DropDownList( $model,'visability', ZHtml::enumItem($model,'visability'),array('empty' => '(Оберіть видимість)')); ?>
		<?php echo $form->error($model,'visability'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'icon'); ?>
		<?php echo $form->textField($model,'icon',array('size'=>60,'maxlength'=>255)); ?>
		<?php echo $form->error($model,'icon'); ?>
	</div>
    <a id="Lnk" href="/ckeditor/kcfinder/browse.php?type=life_icons&langCode=uk" >Завантажити піктограму</a>
	
    <script>
    var link = document.getElementById('Lnk')
    link.setAttribute("onclick","popupWin = window.open(this.href,'contacts','location,top=0'); popupWin.focus(); return false")
    </script>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->