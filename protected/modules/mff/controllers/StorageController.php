<?php

class StorageController extends Controller
{
    public $layout='//layouts/column1';
    public $label='Хранилища свободных форм';
    
    /// Отображает перечень хранилищ
    public function actionIndex()
    {        
        $model = new FFStorage();
        if (isset($_GET["FFStorage"])) $model->attributes=$_GET["FFStorage"];
        $this->render("index",array("model"=>$model));
    }
    
    public function actionInsert()
    {        
        $model = new FFStorage();
        if (Yii::app()->request->isAjaxRequest) {
            echo CActiveForm::validate($model);
            Yii::app()->end();
        }
        if (isset($_POST["FFStorage"])) {
            $model->attributes=$_POST["FFStorage"];
            if ($model->validate()) {
                $model->save();
            }
        }
        $this->redirect(array("index"));
    }
    
    public function actionDelete($id)
    {        
        $model = FFStorage::model()->findByPk($id);
        $model->delete();
        $this->redirect(array("index"));
    }
    
    public function actionUpdate($id)
    {             
        $modelstorage = FFStorage::model()->findByPk($id);
        if (isset($_POST["ajax"]) && ($_POST["ajax"]=="formeditstorage")) {  
            echo CActiveForm::validate($modelstorage);
            Yii::app()->end();                           
        }      
        if (isset($_POST["FFStorage"])) {
            if (isset($_POST["storage-registry-grid_c0"])) {  
                Yii::app()->db->createCommand('call FF_RSCLEAR('.$id.')')->execute();
                foreach ($_POST["storage-registry-grid_c0"] as $value) {
                    Yii::app()->db->createCommand('call FF_RSINIT('.$value.','.$id.')')->execute();
                }
            }
            $modelstorage->attributes=$_POST["FFStorage"];
            if ($modelstorage->validate()) {
                $modelstorage->save();
            }
            $this->redirect(array("index"));
        } else {
            $model=new FFStorage();
            $this->render("index",array("modelstorage"=>$modelstorage,"model"=>$model));
        }                  
    }
    
}