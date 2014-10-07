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
}