<?php
$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden'));
Yii::app()->clientScript->registerScriptFile($this->createUrl("default/getscript",array("script"=>basename(__FILE__,".php"))));
Yii::app()->clientScript->registerCssFile($this->createUrl("default/getcss",array("css"=>basename(__FILE__,".php"))));
