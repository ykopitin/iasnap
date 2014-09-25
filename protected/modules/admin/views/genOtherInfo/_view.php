<?php
/* @var $this GenOtherInfoController */
/* @var $data GenOtherInfo */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('publicationDate')); ?>:</b>
	<?php echo CHtml::encode($data->publicationDate); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('title')); ?>:</b>
	<?php echo CHtml::encode($data->title); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('summary')); ?>:</b>
	<?php echo CHtml::encode($data->summary); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('text')); ?>:</b>
	<?php echo CHtml::encode($data->text); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('img')); ?>:</b>
	<?php echo CHtml::encode($data->img); ?>
	<br />

	<b><?php echo CHtml::encode('Вид публікації'); ?>:</b>
	<?php //echo CHtml::encode($data->kind_of_publication); ?>
	<?php echo CHtml::encode(GenMenuItems::model()->find('id=:id', array(':id'=>$data->kind_of_publication))->content); ?>
	
	<br />


</div>