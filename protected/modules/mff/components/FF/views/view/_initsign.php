<?php
$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden'));
Yii::app()->clientScript->registerScriptFile(Yii::app()->createUrl("/mff/default/getscript",array("script"=>basename(__FILE__,".php"))));
Yii::app()->clientScript->registerCssFile(Yii::app()->createUrl("/mff/default/getcss",array("css"=>basename(__FILE__,".php"))));
