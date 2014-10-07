<?php

class DefaultController extends Controller
{
    public $layout='//layouts/main1';
        
    /// Формирует список сободных форм
    public function actionIndex()
    {        
        $this->render("index");
    }
}