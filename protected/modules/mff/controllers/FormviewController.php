<?php

class FormviewController extends Controller
{
    public $layout='//layouts/column4';
    
    /// 
    public function actionIndex()
    {        
        $this->render("index");
    }
    
  
    
}