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
    
    public function actionIndexStorage($id)
    {        
        $storagemodel = FFStorage::model()->findByPk($id);
        $this->render("indexstorage",array("storagemodel"=>$storagemodel));
    }
    
    public function actionAppend($idregistry,$idstorage)
    {        
        $storagemodel = FFStorage::model()->findByPk($idstorage);
        $this->render("indexstorage",array("idregistry"=>$idregistry,"idstorage"=>$idstorage,"storagemodel"=>$storagemodel));
    }
    
}