<?php
/* @var $this CabUserExternCertsController */
/* @var $data CabUserExternCerts */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('type_of_user')); ?>:</b>
	<?php echo CHtml::encode($data->type_of_user); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certissuer')); ?>:</b>
	<?php echo CHtml::encode($data->certissuer); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certserial')); ?>:</b>
	<?php echo CHtml::encode($data->certserial); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjDRFOCode')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjDRFOCode); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjEDRPOUCode')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjEDRPOUCode); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certData')); ?>:</b>
	<?php echo CHtml::encode($data->certData); ?>
	<br />

	<?php /*
	<b><?php echo CHtml::encode($data->getAttributeLabel('certType')); ?>:</b>
	<?php echo CHtml::encode($data->certType); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('ext_user_id')); ?>:</b>
	<?php echo CHtml::encode($data->ext_user_id); ?>
	<br />
	
	<b><?php echo CHtml::encode($data->getAttributeLabel('certSignTime')); ?>:</b>
	<?php echo CHtml::encode($data->certSignTime); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certUseTSP')); ?>:</b>
	<?php echo CHtml::encode($data->certUseTSP); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certIssuerCN')); ?>:</b>
	<?php echo CHtml::encode($data->certIssuerCN); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubject')); ?>:</b>
	<?php echo CHtml::encode($data->certSubject); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjCN')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjCN); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjOrg')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjOrg); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjOrgUnit')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjOrgUnit); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjTitle')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjTitle); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjState')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjState); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjLocality')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjLocality); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjFullName')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjFullName); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjAddress')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjAddress); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjPhone')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjPhone); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjEMail')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjEMail); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certSubjDNS')); ?>:</b>
	<?php echo CHtml::encode($data->certSubjDNS); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('certExpireEndTime')); ?>:</b>
	<?php echo CHtml::encode($data->certExpireEndTime); ?>
	<br />
	
	*/ ?>

</div>