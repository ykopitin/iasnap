<?php

class FormController extends Controller
{
    public $layout='//layouts/column4';
    
    /// Отображает 
    public function actionIndex()
    {        
        $this->render("index");
    }
}