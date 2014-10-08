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
        $file=$_SERVER['DOCUMENT_ROOT']."/protected/modules/mff/img/".$image;
        header("Content-Type: application/octet-stream");
        header("Accept-Ranges: bytes");
        header("Content-Length: " . filesize($file));
        header("Content-Disposition: attachment; filename=".basename($file));
        readfile($file);
    }
}