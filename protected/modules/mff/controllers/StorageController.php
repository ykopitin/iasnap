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
    
    public function actionDelete($id)
    {        
        $model = FFStorage::model()->findByPk($id);
        $model->delete();
        $this->redirect("index");
    }
    
    public function actionUpdate($id)
    {        
        $model = FFStorage::model()->findByPk($id);
        $model->save();
        $this->redirect(array("index"));
    }
}