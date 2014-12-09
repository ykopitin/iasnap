<?php
Yii::import("mff.components.utils.base58");
class CabinetController extends Controller
{
    public $layout='//layouts/column1';
    public $label='Кабинет';
    public $cabinet_storage=7;
    
    public function actionIndex()
    {
        $this->render('index');
    }
    
    public function actionCabinet($id=null, $folderid=null)
    {        
        $this->render('cabinet',array("cabinetid"=>$id,"folderid"=>$folderid));
    }

    public function actionDoAction($documentid,$actionid,$cabineturl=NULL,$userId=null) {
        $document=FFModel::model()->findByPk($documentid);
        $document->refresh();
        $document->applyAction($actionid,$userId);
        if ($cabineturl==null) {
            $cabineturl='mff.views.cabinet.cabinet';
            $this->render($cabineturl);
        } else {
            $cabineturl= base58::decode($cabineturl);
            header("Location:".$cabineturl);
        }
    }
    
    // Uncomment the following methods and override them if needed
    /*
    public function filters()
    {
            // return the filter configuration for this controller, e.g.:
            return array(
                    'inlineFilterName',
                    array(
                            'class'=>'path.to.FilterClass',
                            'propertyName'=>'propertyValue',
                    ),
            );
    }

    public function actions()
    {
            // return external action classes, e.g.:
            return array(
                    'action1'=>'path.to.ActionClass',
                    'action2'=>array(
                            'class'=>'path.to.AnotherActionClass',
                            'propertyName'=>'propertyValue',
                    ),
            );
    }
    */
}