<?php
/* @var $this CabUserActivitiesController */
/* @var $model CabUserActivities */
/* @var $form CActiveForm */
?>

<div class="wide form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'action'=>Yii::app()->createUrl($this->route),
	'method'=>'get',
)); ?>

	<div class="row">
		<?php echo $form->label($model,'id'); ?>
		<?php echo $form->textField($model,'id',array('size'=>10,'maxlength'=>10)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'portal_user_id'); ?>
		<?php echo $form->textField($model,'portal_user_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'visiting'); ?>
		<?php echo $form->textField($model,'visiting'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'IPAdress'); ?>
		<?php echo $form->textField($model,'IPAdress',array('size'=>15,'maxlength'=>15)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'type'); ?>
		<?php echo $form->textField($model,'type',array('size'=>26,'maxlength'=>26)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'success'); ?>
		<?php echo $form->textField($model,'success'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton('Search'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- search-form -->