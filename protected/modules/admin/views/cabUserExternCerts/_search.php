<?php
/* @var $this CabUserExternCertsController */
/* @var $model CabUserExternCerts */
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
		<?php echo $form->label($model,'type_of_user'); ?>
		<?php echo $form->textField($model,'type_of_user'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certissuer'); ?>
		<?php echo $form->textArea($model,'certissuer',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certserial'); ?>
		<?php echo $form->textField($model,'certserial',array('size'=>40,'maxlength'=>40)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjDRFOCode'); ?>
		<?php echo $form->textField($model,'certSubjDRFOCode',array('size'=>10,'maxlength'=>10)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjEDRPOUCode'); ?>
		<?php echo $form->textField($model,'certSubjEDRPOUCode',array('size'=>10,'maxlength'=>10)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certData'); ?>
		<?php echo $form->textField($model,'certData'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certType'); ?>
		<?php echo $form->textField($model,'certType'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'ext_user_id'); ?>
		<?php echo $form->textField($model,'ext_user_id',array('size'=>10,'maxlength'=>10)); ?>
	</div>

		<div class="row">
		<?php echo $form->label($model,'certSignTime'); ?>
		<?php echo $form->textField($model,'certSignTime'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certUseTSP'); ?>
		<?php echo $form->textField($model,'certUseTSP'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certIssuerCN'); ?>
		<?php echo $form->textArea($model,'certIssuerCN',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubject'); ?>
		<?php echo $form->textArea($model,'certSubject',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjCN'); ?>
		<?php echo $form->textArea($model,'certSubjCN',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjOrg'); ?>
		<?php echo $form->textArea($model,'certSubjOrg',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjOrgUnit'); ?>
		<?php echo $form->textArea($model,'certSubjOrgUnit',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjTitle'); ?>
		<?php echo $form->textArea($model,'certSubjTitle',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjState'); ?>
		<?php echo $form->textArea($model,'certSubjState',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjLocality'); ?>
		<?php echo $form->textArea($model,'certSubjLocality',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjFullName'); ?>
		<?php echo $form->textArea($model,'certSubjFullName',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjAddress'); ?>
		<?php echo $form->textArea($model,'certSubjAddress',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjPhone'); ?>
		<?php echo $form->textArea($model,'certSubjPhone',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjEMail'); ?>
		<?php echo $form->textArea($model,'certSubjEMail',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certSubjDNS'); ?>
		<?php echo $form->textArea($model,'certSubjDNS',array('rows'=>6, 'cols'=>50)); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'certExpireEndTime'); ?>
		<?php echo $form->textField($model,'certExpireEndTime'); ?>
	</div>
	
	<div class="row buttons">
		<?php echo CHtml::submitButton('Search'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- search-form -->
