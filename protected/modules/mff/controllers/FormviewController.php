<?php
class FormviewController extends Controller
{
    public $layout='//layouts/column1';
    public $label='Наполнение хранилищ';
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
    
    public function actionSave($idregistry,$idstorage,$scenario="insert",$idform=null,$layouts="indexstorage")
    {        
//        echo '<pre>';
//        var_dump($_POST);
//        echo '</pre>';
//        return;
        $storagemodel = FFStorage::model()->findByPk($idstorage);
        $registrymodel = FFRegistry::model()->findByPk($idregistry);
        if (isset($_POST["FFModel"])) {
            $idguide=array();
            foreach ($_POST as $key => $value) {
                if (strpos($key, "FFModel_") !== false) {
                    $fieldname=substr($key,strlen("FFModel_"));
                    eval("class $key extends FFModel {}");
                    $vFFModel=new $key;
                    if ($scenario=="insert") {
                        $vFFModel->registry=$_POST[$key]["registry"];
                        $vFFModel->refreshMetaData();
                        $vFFModel->setAttributes($_POST[$key], FALSE);
                        if ($vFFModel->validate() && $vFFModel->save()){
                            $idguide=array_merge($idguide,array($fieldname=>$vFFModel->id));
                        }
                    }
                    if ($scenario=="update") {
                         $vFFModel->registry=1;
                         $vFFModel->tablename();
                         $vFFModel->refreshMetaData();
                         $vFFModel=$vFFModel->findByPk($_POST["FFModel"][$fieldname]);
                         $vFFModel->refreshMetaData();
                         $vFFModel->refresh();
                         $vFFModel->setAttributes($_POST[$key], FALSE);
                         if ($vFFModel->validate() && $vFFModel->save()){
                            $idguide=array_merge($idguide,array($fieldname=>$vFFModel->id));
                         }
                    }
                }
            }
            if ($scenario=="insert") {
                $datamodel=new FFModel("insert");               
            }
            if ($scenario=="update" && $idform!=null){
                $datamodel=FFModel::model()->findByPk($idform);
            }  
            $datamodel->registry=$idregistry;
            $datamodel->refreshMetaData();
//            $datamodel->unsetAttributes();
            $dataold=$datamodel->attributes;           
            $datamodel->setAttributes($_POST["FFModel"], FALSE);
     
            $datamodel->storage=$idstorage;
            $datamodel->registry=$idregistry;
            
            // Загрузка картинок, файлов
            if (isset($_FILES) && isset($_FILES[get_class($datamodel)]) && isset($_FILES[get_class($datamodel)]["tmp_name"])) {
                foreach ($_FILES[get_class($datamodel)]["tmp_name"] as $key => $value) {                    
                    if ($_FILES[get_class($datamodel)]["size"][$key]!=0 || file_exists($value) ) {
                        $datamodel->$key=file_get_contents($value);                        
                        $field=FFField::model()->find("`formid`=:formid and `name`=:name",array(":formid"=>$idregistry,":name"=>$key)) ;
                        if (isset($field) && $field!=null) {
                            switch ($field->type) {
                                case 10:
                                    $datamodel->setAttribute($key."_filename", $_FILES[get_class($datamodel)]["name"][$key]);
                                    $datamodel->setAttribute($key."_filetype", $_FILES[get_class($datamodel)]["type"][$key]);
                                break;
                            }
                        }
                    }
                    else $datamodel->$key=$dataold[$key];
                }          
            }
            
            foreach ($idguide as $key => $value) {
                $datamodel->$key=$value;
            }

           if ($datamodel->validate() && $datamodel->save()) {
                foreach ($_POST as $key => $value) {
                    $partkey=explode("_",$key);
                    if ($partkey[0]=="multiguide") {
                        $classnamefiled="FFModel_".$key;
                        eval("class $classnamefiled extends FFModel {}");
                        Yii::app()->db->createCommand("DELETE FROM `ff_ref_multiguide` WHERE `owner_field`=:owner_field and `owner`=".$datamodel->id)->execute(array(":owner_field"=>$partkey[1]));
                        $multi_value=$_POST[$key];                       
                        foreach ($multi_value as $index => $itemid) {
                            $vf2FFModel=new $classnamefiled;
                            $vf2FFModel->registry=FFModel::ref_multiguide;
                            $vf2FFModel->storage=FFModel::ref_multiguide_storage;
                            $vf2FFModel->tableName();
                            $vf2FFModel->refreshMetaData();
                            $vf2FFModel->setAttribute("order",$index);
                            $vf2FFModel->setAttribute("owner",$datamodel->id);
                            $vf2FFModel->setAttribute("owner_field",$partkey[1]);
                            $vf2FFModel->setAttribute("reference",$itemid);
                            $vf2FFModel->save();
                        }
                    }
                }
                $this->redirect(array($layouts,"id"=>$idstorage));
                return;
            }       
        }
        $this->render($layouts,
                array(
                    "idregistry"=>$idregistry,
                    "idstorage"=>$idstorage,
                    "storagemodel"=>$storagemodel,
                    "scenario"=>$scenario,
                    "idform"=>$idform,
                    )
                );
    }
    
    /// Добавить удаление встраиваемых справочников
    public function actionDelete($idform,$idstorage){
        $datamodel=FFModel::model()->findByPk($idform);        
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
    
    public function actionGetImage($id,$name) {
        $model=FFModel::model()->findByPk($id);
        $model->refreshMetaData();
        $model->refresh();
        echo $model->getAttribute($name);
    }
    
    public function actionGetFile($id,$name) {
        $model=FFModel::model()->findByPk($id);
        $model->refreshMetaData();
        $model->refresh();
        if ($model->hasAttribute($name."_filetype")) {
            header("Content-Type: ".$model->getAttribute($name."_filetype"));
        }
        header("Content-Disposition: attachment; filename=".$model->getAttribute($name."_filename"));
        echo $model->getAttribute($name);
    }
    
    public function actionGetFileSigned($id,$name) {
        $model=FFModel::model()->findByPk($id);
        $model->refreshMetaData();
        $model->refresh();
        header("Content-Disposition: attachment; filename=".$model->getAttribute($name."_fileedsname"));
        echo $model->getAttribute($name);
    }
     
    public function actionFindStorage() {
        $handle=fopen("test.txt", "a");
        fwrite($handle, "P=". serialize($_POST)."\n");
        fwrite($handle, "G=". serialize($_GET)."\n");
        fclose($handle);    
    }
}