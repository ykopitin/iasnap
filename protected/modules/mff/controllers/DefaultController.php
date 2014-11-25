<?php

class DefaultController extends Controller
{
    public $layout='//layouts/main1';
    public $label='Меню свободных форм';
    
    /// Формирует список сободных форм
    public function actionIndex()
    {        
        $this->render("index");
    }
    
    /// Тестирование одиночных СФ
    public function actionTestFF() {
        $this->render("testff");
    }
    
    public function actionGetimage($image) {        
        $file=Yii::getPathOfAlias('mff.img').DIRECTORY_SEPARATOR.$image.".png";
        header("Content-Type: application/png");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }
    
    public function actionGetJScan() {        
        $file=Yii::getPathOfAlias('mff.components.ffscan').DIRECTORY_SEPARATOR."JScan.jar";
        header("Content-Type: application/java");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }
    
    public function actionGetScript($script, $fullAlias=false) {       
        if ($fullAlias) $file=Yii::getPathOfAlias(base64_decode($script)).".js";
        else $file=Yii::getPathOfAlias('mff.scripts').DIRECTORY_SEPARATOR.$script.".js";           
        header("Content-Type: text/javascript");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }
 
    public function actionGetCSS($css, $fullAlias=false) {       
        if ($fullAlias) $file=Yii::getPathOfAlias(base64_decode($css)).".css";        
        else  $file=Yii::getPathOfAlias('mff.css').DIRECTORY_SEPARATOR.$css.".css";    
        header("Content-Type: text/css");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }

}