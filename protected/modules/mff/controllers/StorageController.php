<?php

class FormController extends Controller
{
    public $layout='//layouts/column4';
    //public $defaultAction='listforms';
    
    /// Отображает 
    public function actionIndex($id)
    {        
        $this->render("index");
    }
}