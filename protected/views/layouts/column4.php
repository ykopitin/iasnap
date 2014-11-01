<?php /* @var $this Controller */ ?>
<?php //$this->beginContent('//layouts/main1'); ?>
<?php $this->beginContent('//layouts/column1'); ?>
<table style="width: 90%;" align="left">
    <tr>
        <td style="width:  720px; padding: 27px 0 10px 140px; vertical-align: top;"><?php echo $content; ?></td>
        <td style="width:190px; margin-right:0; padding: 0 0 0 40px; vertical-align: top;">
            <?php
		$this->beginWidget('zii.widgets.CPortlet', array(
			'title'=>'Генерація вільних форм',
		));
		$this->widget('zii.widgets.CMenu', array(
			'items'=>$this->menu,
			'htmlOptions'=>array('class'=>'operations'),
                        'encodeLabel'=>FALSE,
		));
		$this->endWidget();
	?>
        </td>
    </tr>
</table>
<?php $this->endContent(); ?>