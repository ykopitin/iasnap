<?php

class DefaultController extends Controller
{
    public $layout='//layouts/column4';
    //public $defaultAction='listforms';
    
    /// Формирует список сободных форм
    public function actionIndex($parentid=null)
    {        
        $this->render('listforms',array("parentid"=>$parentid));
    }

    /// Переключает в режим редактирования свободной формы
    public function actionEdit($id,$parentid=null)
    {
        $this->render("listforms", array("parentid"=>$parentid,"id"=>$id));
    }
    
    /// Сохраняет сформиророваную свободную форму
    public function actionSave($parentid=null)
    {
    }
    
    /// Удаляет свободную форму
    public function actionDelete($id, $parentid=null)
    {
        FFRegistry::model()->findByPk($id)->delete();
    }
    
    /// Создает новую свободную форму
    public function actionNew($parentid=1)
    {
        $this->render("listforms", array("parentid"=>$parentid));
    }
    
    /// Добавляет новое поле в свободной форме
    public function actionFieldNew($formid)
    {
        $field=new FFField('insert');
        if(isset($_POST['ajax']) && $_POST['ajax']==='formaddfield') 
        {
            echo CActiveForm::validate($field);
            Yii::app()->end();
        }
        if (isset($_POST["FFField"])) {
            $field->attributes = $_POST["FFField"];
            $registry = FFRegistry::model()->findByPk($formid);
            $parentid = ($registry->parent===null)?null:$registry->parentItem->id;
            if ($field->validate()) {
                $field->save();
            }
            $this->redirect($this->createUrl("default/edit", array("parentid"=>$parentid,"id"=>$formid)));
        }
    }
   
    /// Удаляет поле в свободной форме
    public function actionFieldDelete($idfield)
    {
        $field = FFField::model()->findByPk($idfield);
        $formid = $field->formid;
        $parentid = ($field->registryItem->parent===null)?null:$field->registryItem->parent->id;
        $field->delete();
        $this->redirect($this->createUrl("default/edit", array("parentid"=>$parentid,"id"=>$formid)));       
    }

    /// Исправляет поле в свободной форме
    public function actionFieldEdit($idfield)
    {
        $field = FFField::model()->findByPk($idfield);
        $formid = $field->formid;
        $parentid = ($field->registryItem->parent===null)?null:$field->registryItem->parent->id;
        
        $field->save();
        $this->redirect($this->createUrl("default/edit", array("parentid"=>$parentid,"id"=>$formid)));       
    }
    
   
}