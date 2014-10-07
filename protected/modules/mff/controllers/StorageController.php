<?php

class FormController extends Controller
{
    public $layout='//layouts/main1';
    
    /// Отображает 
    public function actionIndex()
    {        
        $this->render("index");
    }
}