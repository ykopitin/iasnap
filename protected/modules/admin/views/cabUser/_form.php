<?php
/* @var $this CabUserController */
/* @var $model CabUser */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'cab-user-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'type_of_user'); ?>
		<?php echo $form->textField($model,'type_of_user'); ?>
		<?php echo $form->error($model,'type_of_user'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'fio'); ?>
		<?php echo $form->textField($model,'fio',array('size'=>60,'maxlength'=>100)); ?>
		<?php echo $form->error($model,'fio'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'organization'); ?>
		<?php echo $form->textField($model,'organization',array('size'=>60,'maxlength'=>100)); ?>
		<?php echo $form->error($model,'organization'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'email'); ?>
		<?php echo $form->textField($model,'email',array('size'=>45,'maxlength'=>45)); ?>
		<?php echo $form->error($model,'email'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'phone'); ?>
		<?php echo $form->textField($model,'phone',array('size'=>12,'maxlength'=>12)); ?>
		<?php echo $form->error($model,'phone'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'cab_state'); ?>
		<?php //echo $form->textField($model,'cab_state',array('size'=>27,'maxlength'=>27)); ?>
		<?php echo $form->DropDownList( $model,'cab_state', ZHtml::enumItem($model,'cab_state'),array('empty' => '(Оберіть стан облікового запису)')); ?>
		<?php echo $form->error($model,'cab_state'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'authorities_id'); ?>
		<?php //echo $form->textField($model,'authorities_id'); ?>
		<?php echo $form->dropDownList($model, 'authorities_id', CHtml::listData(GenAuthorities::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть місце надання послуг)')); ?>
		<?php echo $form->error($model,'authorities_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'user_roles_id'); ?>
		<?php //echo $form->textField($model,'user_roles_id'); ?>
		<?php echo $form->dropDownList($model, 'user_roles_id', CHtml::listData(CabUserRoles::model()->findAll(), 'id', 'user_role'),array('empty' => '(Роль користувача)')); ?>
		<?php echo $form->error($model,'user_roles_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'str_tdata'); ?>
		<?php echo $form->textField($model,'str_tdata',array('size'=>40,'maxlength'=>40)); ?>
		<?php echo $form->error($model,'str_tdata'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Create' : 'Save'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->
