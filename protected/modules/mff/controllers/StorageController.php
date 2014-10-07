<?php

class FormController extends Controller
{
    public $layout='//layouts/column4';
    
    /// Отображает 
    public function actionIndex($id)
    {        
        $this->render("index");
    }
}