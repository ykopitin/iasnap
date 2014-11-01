<?php

class CabinetController extends Controller
{
    public $layout='//layouts/column1';
    public $label='Кабинет';
    public $cabinet_storage=7;
    
    public function actionIndex()
    {
        $this->render('index');
    }
    
    public function actionCabinet($id=null)
    {
        $cabinetmodel=FFModel::model()->findByPk($id);
        $cabinetmodel->refresh();
        $this->render('cabinet',array("cabinetmodel"=>$cabinetmodel));
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