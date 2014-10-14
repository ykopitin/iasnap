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
    
    public function actionBarcode($id="0",$code="BCGean13"){
        $text="482000000000";
        $text=str_pad($id, 12, $text, STR_PAD_LEFT);
        Yii::import("application.extensions.barcodegen.*");
        require_once('BCGFontFile.php');
        require_once('BCGColor.php');
        require_once('BCGDrawing.php');
        require_once($code.'.barcode.php');
        $fontpath=Yii::getPathOfAlias("application.extensions.barcodegen.font.Arial").'.ttf';
        $font = new BCGFontFile($fontpath, 8);
        $color_black = new BCGColor(0, 0, 0);
        $color_white = new BCGColor(255, 255, 255);
        $color_white->setTransparent(true);
        $drawException = null;
        try {
            $code = new $code();
            $code->setScale(1.5); // Resolution
            $code->setThickness(20); // Thickness
            $code->setForegroundColor($color_black); // Color of bars
            $code->setBackgroundColor($color_white); // Color of spaces
            $code->setFont($font); // Font (or 0)
            $code->parse($text); // Text           
        } catch(Exception $exception) {
            $drawException = $exception;
        }
        $drawing = new BCGDrawing('', $color_white);
        if($drawException) {
            $drawing->drawException($drawException);
        } else {
            $drawing->setBarcode($code);
            $drawing->draw();
        }

        header('Content-Type: image/png');
        header('Content-Disposition: inline; filename="barcode.png"');
        $drawing->finish(BCGDrawing::IMG_FORMAT_PNG);
    }
    
}