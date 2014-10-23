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
    
    public function actionGetimage($image) {
        
//        $file=Yii::getPathOfAlias('webroot')."/protected/modules/mff/img/".$image.".png";
        $file=Yii::getPathOfAlias('mff.img').DIRECTORY_SEPARATOR.$image.".png";
//        echo $file;
        header("Content-Type: application/png");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }
    
    public function actionGetScript($script) {       
        $file=Yii::getPathOfAlias('mff.scripts').DIRECTORY_SEPARATOR.$script.".js";
        header("Content-Type: text/javascript");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }
 
    public function actionGetCSS($css) {       
        $file=Yii::getPathOfAlias('mff.css').DIRECTORY_SEPARATOR.$css.".css";
        header("Content-Type: text/css");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }

}