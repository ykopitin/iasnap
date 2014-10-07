<?php

class FormviewController extends Controller
{
    public $layout='//layouts/main1';
    public $label='Тестирование свободных форм';
    /// 
    public function actionIndex()
    {        
        $this->render("index");
    }
    
  
    
}