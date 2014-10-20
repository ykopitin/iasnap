<?php

class FormgenController extends Controller
{
    public $layout='//layouts/column4';
    //public $defaultAction='listforms';
    public $label = "Генератор свободных форм";
    
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
    
    /// Сохраняет сформиророваную свободную форму (при редактировании)
    public function actionSave()
    {
        if (isset($_POST["FFRegistry"])) {
            $registry = FFRegistry::model()->findByPk($_POST["FFRegistry"]["id"]);
            $registry->description = $_POST["FFRegistry"]["description"];
            $registry->copying = $_POST["FFRegistry"]["copying"];

            if ($registry->validate()) {
                if ($registry->save()) {
                    $this->redirect(array("index","parentid"=>$registry->parent));
                }
            }        
            $this->redirect(array("edit","parentid"=>$registry->parent,"id"=>$registry->id));
       }
       $this->redirect("index");
    }
    
    /// Удаляет свободную форму
    public function actionDelete($id, $parentid=null)
    {
        FFRegistry::model()->findByPk($id)->delete();
        $this->redirect(array("index","parentid"=>$parentid));
    }
    
    /// Создает новую свободную форму
    public function actionNew($parentid)
    {        
        $registry=new FFRegistry('insert');
        if(isset($_POST['ajax']) && $_POST['ajax']==='formnew') 
        {
            echo CActiveForm::validate($registry);
            Yii::app()->end();
        }
        if (isset($_POST["FFRegistry"])) {
            $registry->attributes = $_POST["FFRegistry"];
             if ($registry->validate()) {
                if ($registry->save()) {
                    $this->redirect(array("index","parentid"=>$parentid));
                }
            }        
       }
       $this->render("listforms", array("parentid"=>$parentid, "registry"=>$registry));
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
            $this->redirect($this->createUrl("edit", array("parentid"=>$parentid,"id"=>$formid)));
        }
    }
   
    /// Удаляет поле в свободной форме
    public function actionFieldDelete($idfield)
    {
        $field = FFField::model()->findByPk($idfield);
        $formid = $field->formid;
        $parentid = ($field->formid==null)?null:(($field->registryItem->parent==null)?null:$field->registryItem->parent);
        $field->delete();
        $this->redirect($this->createUrl("edit", array("parentid"=>$parentid,"id"=>$formid)));       
    }

    /// Исправляет поле в свободной форме
    public function actionFieldEdit()
    {
        $field = new FFField;
        if(isset($_POST['ajax'])) 
        {
            echo CActiveForm::validate($field);
            Yii::app()->end();
        }
        
        if (isset($_POST["FFField"])) {
            $field = FFField::model()->findByPk($_POST["FFField"]["id"]);
            $field->name = $_POST["FFField"]["name"];
            $field->type = $_POST["FFField"]["type"];
            $field->order = $_POST["FFField"]["order"];
            $field->description = $_POST["FFField"]["description"];
            $formid = $field->formid;
            $parentid = ($formid==null)?null:$field->registryItem->parent; 
            if ($field->validate()) {      
                $field->save();
            }
            $this->redirect($this->createUrl("edit", array("parentid"=>$parentid,"id"=>$formid)));    
        } else {
            $this->redirect("index");
        }
    }
    
   public function actionRegistry($parentid=null) {
       $modelregistry = new FFRegistry;
       $modelregistry->parent=null;
       $modelregistry->attaching=1;
       $modelregistry->copying=0;
       if(isset($_POST['ajax'])) 
       {
            echo CActiveForm::validate($modelregistry);
            Yii::app()->end();
       }
       if (isset($_POST["FFRegistry"])) {
            $modelregistry->attributes=$_POST["FFRegistry"];
            if ($modelregistry->validate() && $modelregistry->save()) {
                $this->redirect("index");
            }
       }
       $this->render("listforms",array("parentid"=>null,"modelregistry"=>$modelregistry));
   }
   
}