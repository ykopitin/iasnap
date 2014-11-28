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
      
    public function actionSave($idregistry=null,$idstorage=null,$scenario="insert",$idform=null,$thisrender=null,$backurl=null,$addons=null)
    {        
        if ($backurl!=null) $backurl=base64_decode($backurl);
        if ($thisrender!=null) $thisrender=base64_decode($thisrender);
        if (isset($_POST["FFModel"])) {
//            $transaction=  Yii::app()->db->beginTransaction();
            $idguide=array();
            // Похоже для работы со встраиваимыми справочниками
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
                         $vFFModel->refreshMetaData();
                         $vFFModel=$vFFModel->findByPk($_POST["FFModel"][$fieldname]);
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
                $datamodel->registry=$idregistry;
                $datamodel->refreshMetaData();
            }
            if ($scenario=="update" && $idform!=null){
                $datamodel=FFModel::model()->findByPk($idform);                
                $datamodel->refresh();
                $idregistry=$datamodel->registry;
            }  
                        
            $dataold=$datamodel->attributes;           
            $datamodel->setAttributes($_POST["FFModel"], FALSE);
            
            $datamodel->storage=$idstorage;
            $datamodel->registry=$idregistry;
            
            // Проверяем значения по умолчанию 
            $route=null;
            $_addons=null;
            $firstdefault=FALSE;
            if (isset($addons) || $addons!=NULL) {
                $_addons=base64_decode($addons);
                eval('$_addons='.$_addons.";");
                
                if (is_array($_addons) && isset($_addons["fielddefaults"])) {
                    $datamodel->setAttributes($_addons["fielddefaults"],FALSE);
                    $firstdefault=TRUE;
                }
            }

            $fields=FFField::model()->findAll("(`formid`=:formid) and (`default` is not null)",array(":formid"=>$idregistry));
            foreach ($fields as $field) {
                if ($scenario=="insert" && substr(trim($field->default), 0, strlen("AISTATIC:"))=="AISTATIC:") { 
                    $data=trim(substr(trim($field->default), strlen("AISTATIC:")));
                    $datamodel->setAttribute($field->name, $data);
                }
                if ($scenario=="update" && substr(trim($field->default), 0, strlen("AUSTATIC:"))=="AUSTATIC:") { 
                    $data=trim(substr(trim($field->default), strlen("AUSTATIC:")));
                    $datamodel->setAttribute($field->name, $data);
                }
                if ($scenario=="insert" && substr(trim($field->default), 0, strlen("AIPHP:"))=="AIPHP:") { 
                    $data=eval(trim(substr(trim($field->default), strlen("AIPHP:"))));
                    $datamodel->setAttribute($field->name, $data);
                }
                if ($scenario=="update" && substr(trim($field->default), 0, strlen("AUPHP:"))=="AUPHP:") { 
                    $data=eval(trim(substr(trim($field->default), strlen("AUPHP:"))));
                    $datamodel->setAttribute($field->name, $data);
                }
                if (!$firstdefault && $scenario=="insert" && substr(trim($field->default), 0, strlen("AI_ROUTE_AND_APLLY_FIRST_ACTION:"))=="AI_ROUTE_AND_APLLY_FIRST_ACTION:") { 
                    $data=trim(substr(trim($field->default), strlen("AI_ROUTE_AND_APLLY_FIRST_ACTION:")));
//                    echo 'Value:'.$data."<br />";
                    $datamodel->setAttribute($field->name, $data);
                    $route=array($field->name => $data);
                }
            }
            
//            echo '<pre>';var_dump($datamodel);echo '</pre>';
//            return;
            
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
               // Очищаем свзки многие-ко-многим
               Yii::app()->db->createCommand( "DELETE FROM `ff_ref_multiguide` WHERE `owner`=".$datamodel->id)->execute();
                if ($scenario=="insert") {
                     // Маршрутизация
                     if ($route!=null) {
                        $userId=  Yii::app()->user->id;
                        if (isset($userId) && $userId!=NULL) {
                            $datamodel->applyRoute($userId,TRUE);
                        } else {
                            $datamodel->applyRoute(null,TRUE);
                        }
                     } else {
                         $datamodel->applyRoute();
                     }
                }                
                foreach ($_POST as $key => $value) {
                    $partkey=explode("_",$key);
                    if ($partkey[0]=="multiguide") {
                        $fieldname=substr($key, 11);
                        $multi_value=$_POST[$key];                         
                        $datamodel->setMultiGuide($fieldname, $multi_value);
                    }
                }    
                
//                $transaction->commit();
                try {
                    @$backurlparams=  unserialize($backurl);
                    if(!$backurlparams) {
                        $this->redirect($backurl);
                    } else {
                        switch (count($backurlparams)) {
                        case 1:
                            $this->redirect($backurlparams[0]);
                            break;
                         case 2:
                            $this->redirect($backurlparams[0],$backurlparams[1]);
                            break;
                        }
                    }
                } catch (Exception $e) {
                    $this->redirect($backurl);
                }
                return;
            }      
//            $transaction->rollback();
        }    
        $data=array("idregistry"=>$idregistry,"idstorage"=>$idstorage,"scenario"=>$scenario,"idform"=>$idform,"backurl"=>base64_encode($backurl),"thisrender"=>base64_encode($thisrender),"addons"=>$addons);    
        $this->render($thisrender,$data);
    }
    
    /// Добавить удаление встраиваемых справочников
    public function actionDelete($idform,$backurl){
        $backurl=base64_decode($backurl);
        $datamodel=FFModel::model()->findByPk($idform);        
        $datamodel->delete();
        $this->redirect($backurl);  
    }
    
    public function actionBarcode($id="0",$code="BCGean13"){
        Yii::import("mff.components.utils.tracknumberUtil");
        $text=  tracknumberUtil::getTracknumberFromId($id);
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
