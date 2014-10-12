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
    
    public function actionSave($idregistry,$idstorage,$idform=null,$scenario="insert")
    {        
//        if (isset($_POST["ajax"]) && $_POST["ajax"]=="formff" ){
//            if ($scenario=="insert") {
//                $datamodel=new FFModel("insert");               
//            }
//            if ($scenario=="update" && $idform!=null){
//                $datamodel=  FFModel::model()->findByPk($idform);
//            }  
//            echo CActiveForm::validate($datamodel);
//            Yii::app()->end();
//        }
        $storagemodel = FFStorage::model()->findByPk($idstorage);
        $registrymodel = FFRegistry::model()->findByPk($idregistry);
        if (isset($_POST["FFModel"])) {
            
            if ($scenario=="insert") {
                $datamodel=new FFModel("insert");               
            }
            if ($scenario=="update" && $idform!=null){
                $datamodel=  FFModel::model()->findByPk($idform);
            }  
            $datamodel->registry=$idregistry;
            $datamodel->refreshMetaData();
            $datamodel->unsetAttributes();
            $datamodel->setAttributes($_POST["FFModel"], FALSE);
            $datamodel->storage=$idstorage;
            $datamodel->registry=$idregistry;
           
            if ($datamodel->validate() && $datamodel->save()) {
//                $this->render("indexstorage",
//                        array(
//                            "idregistry"=>$idregistry,
//                            "idstorage"=>$idstorage,
//                            "storagemodel"=>$storagemodel,
//                            "scenario"=>"update",
//                            "datamodel"=>$datamodel,
//                            ));
                $this->redirect(array("indexstorage","id"=>$idstorage));
                return;
            }
        
        }
        $this->render("indexstorage",array("idregistry"=>$idregistry,"idstorage"=>$idstorage,"storagemodel"=>$storagemodel));
    }
    
    public function actionDelete($idform,$idstorage){
        $datamodel=  FFModel::model()->findByPk($idform);
        $datamodel->delete();
        $this->redirect(array("indexstorage","id"=>$idstorage));
    }
    
}