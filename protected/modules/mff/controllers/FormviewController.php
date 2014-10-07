<?php

class FormviewController extends Controller
{
    public $layout='//layouts/main1';
    
    /// 
    public function actionIndex()
    {        
        $this->render("index");
    }
    
  
    
}