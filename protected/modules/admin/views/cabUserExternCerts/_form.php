<?php
/* @var $this CabUserExternCertsController */
/* @var $model CabUserExternCerts */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'cab-user-extern-certs-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'id'); ?>
		<?php echo $form->textField($model,'id',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'type_of_user'); ?>
		<?php echo $form->textField($model,'type_of_user'); ?>
		<?php echo $form->error($model,'type_of_user'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certissuer'); ?>
		<?php echo $form->textArea($model,'certissuer',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certissuer'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certserial'); ?>
		<?php echo $form->textField($model,'certserial',array('size'=>40,'maxlength'=>40)); ?>
		<?php echo $form->error($model,'certserial'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjDRFOCode'); ?>
		<?php echo $form->textField($model,'certSubjDRFOCode',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'certSubjDRFOCode'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjEDRPOUCode'); ?>
		<?php echo $form->textField($model,'certSubjEDRPOUCode',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'certSubjEDRPOUCode'); ?>
	</div>

<!--	<div class="row"> -->
		<?php /*echo $form->labelEx($model,'certData'); */?>
		<?php /*echo $form->textField($model,'certData'); */?>
		<?php /*echo $form->error($model,'certData'); */?>
<!--	</div> -->

	<div class="row">
		<?php echo $form->labelEx($model,'certType'); ?>
		<?php echo $form->textField($model,'certType'); ?>
		<?php echo $form->error($model,'certType'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'ext_user_id'); ?>
		<?php echo $form->textField($model,'ext_user_id',array('size'=>10,'maxlength'=>10)); ?>
		<?php echo $form->error($model,'ext_user_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSignTime'); ?>
		<?php echo $form->textField($model,'certSignTime'); ?>
		<?php echo $form->error($model,'certSignTime'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certUseTSP'); ?>
		<?php echo $form->textField($model,'certUseTSP'); ?>
		<?php echo $form->error($model,'certUseTSP'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certIssuerCN'); ?>
		<?php echo $form->textArea($model,'certIssuerCN',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certIssuerCN'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubject'); ?>
		<?php echo $form->textArea($model,'certSubject',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubject'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjCN'); ?>
		<?php echo $form->textArea($model,'certSubjCN',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjCN'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjOrg'); ?>
		<?php echo $form->textArea($model,'certSubjOrg',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjOrg'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjOrgUnit'); ?>
		<?php echo $form->textArea($model,'certSubjOrgUnit',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjOrgUnit'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjTitle'); ?>
		<?php echo $form->textArea($model,'certSubjTitle',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjTitle'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjState'); ?>
		<?php echo $form->textArea($model,'certSubjState',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjState'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjLocality'); ?>
		<?php echo $form->textArea($model,'certSubjLocality',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjLocality'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjFullName'); ?>
		<?php echo $form->textArea($model,'certSubjFullName',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjFullName'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjAddress'); ?>
		<?php echo $form->textArea($model,'certSubjAddress',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjAddress'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjPhone'); ?>
		<?php echo $form->textArea($model,'certSubjPhone',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjPhone'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjEMail'); ?>
		<?php echo $form->textArea($model,'certSubjEMail',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjEMail'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certSubjDNS'); ?>
		<?php echo $form->textArea($model,'certSubjDNS',array('rows'=>6, 'cols'=>50)); ?>
		<?php echo $form->error($model,'certSubjDNS'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'certExpireEndTime'); ?>
		<?php echo $form->textField($model,'certExpireEndTime'); ?>
		<?php echo $form->error($model,'certExpireEndTime'); ?>
	</div>	
	
	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->
