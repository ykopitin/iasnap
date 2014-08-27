<?php

class DefaultController extends Controller
{
    public $layout='//layouts/column2';
    
    public function actionIndex()
    {
        $model = new FormStorage();
        $this->render('index',$model);
    }

    public function actionCreate() 
    {
        $this->render('index');
    }

    public function actionEdit($name) 
    {
        $this->render('index');
    }
}