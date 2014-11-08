<?php
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];

$this->widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden'));
Yii::app()->clientScript->registerScriptFile(Yii::app()->createUrl("/mff/default/getscript",array("script"=>basename(__FILE__,".php"))));
Yii::app()->clientScript->registerCssFile(Yii::app()->createUrl("/mff/default/getcss",array("css"=>basename(__FILE__,".php"))));
