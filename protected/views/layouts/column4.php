<?php /* @var $this Controller */ ?>
<?php 
$this->beginContent('//layouts/column1'); 
Yii::app()->clientScript->registerCssFile($this->createUrl("/mff/default/getcss",array("css"=>basename(__FILE__,".php"))));

?>
<table style="width: 100%;" align="left">
    <tr>
        <td style="padding: 4px 0 0 4px; vertical-align: top;"><?php echo $content; ?></td>
        <td style="width:190px; margin-right:0; padding: 0 0 0 14px; vertical-align: top;">
            <?php
		$this->beginWidget('zii.widgets.CPortlet', array(
			'title'=>'Генерація вільних форм',
                        'decorationCssClass'=>'portlet-decoration-mff',
                        'titleCssClass'=>'portlet-title-mff',
                        'contentCssClass'=>'portlet-content-mff',
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