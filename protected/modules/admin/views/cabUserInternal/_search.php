<?php
/* @var $this CabUserInternalController */
/* @var $model CabUserInternal */
/* @var $form CActiveForm */
?>

<div class="wide form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'action'=>Yii::app()->createUrl($this->route),
	'method'=>'get',
)); ?>

	<div class="row">
		<?php echo $form->label($model,'id'); ?>
		<?php echo $form->textField($model,'id'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'authorities_id'); ?>
		<?php echo $form->textField($model,'authorities_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'user_roles_id'); ?>
		<?php echo $form->textField($model,'user_roles_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'cab_state'); ?>
		<?php echo $form->textField($model,'cab_state',array('size'=>22,'maxlength'=>22)); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton('Search'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- search-form -->