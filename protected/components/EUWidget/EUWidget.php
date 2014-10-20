<?php
class EUWidget extends CWidget {
    public $WidgetType = "Login"; // available: Sign, Hidden
    public $model;
    public $WidgetAction = "";
    public function init(){
//        $this->model = $model;
        $assetsDir = dirname(__FILE__).DIRECTORY_SEPARATOR;
	$baseUrl = Yii::app()->assetManager->publish($assetsDir.'/assets');
//        Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/js/jquery.js');
	if ($this->WidgetType == "Login") {
	        Yii::app()->clientScript->registerScriptFile($baseUrl.'/EULoginMini.js');
		$this->WidgetAction = "sign/login";
	}
	else if ($this->WidgetType == "Sign") {
	        Yii::app()->clientScript->registerScriptFile($baseUrl.'/EUSignMini.js');
		if ($this->WidgetAction == "") $this->WidgetAction = "sign/sign";
	}
	else if ($this->WidgetType == "Hidden")
	        Yii::app()->clientScript->registerScriptFile($baseUrl.'/EUHiddenMini.js');
        Yii::app()->clientScript->registerScriptFile($baseUrl.'/EUSignScripts3.js');
        Yii::app()->clientScript->registerScriptFile($baseUrl.'/base64ie.js');
        Yii::app()->clientScript->registerCssFile($baseUrl.'/EUStyles2.css');
    }

    public function run() {
        $this->render('eubutton', $this->model);
    }
    
    
}
?>
