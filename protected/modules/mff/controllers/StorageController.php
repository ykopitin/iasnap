<?php

class StorageController extends Controller
{
    public $layout='//layouts/main1';
    public $label='Хранилища свободных форм';
    
    /// Отображает перечень хранилищ
    public function actionIndex()
    {        
        $model = new FFStorage();
        $this->render("index",array("model"=>$model));
    }
}