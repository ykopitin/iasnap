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
    public function actionSave($id, $parentid=null)
    {
        FFRegistry::model()->findByPk($id)->save();
        $this->redirect($this->createUrl("mff/default/index", array("parentid"=>$parentid)));
    }
    
    /// Удаляет свободную форму
    public function actionDelete($id, $parentid=null)
    {
        FFRegistry::model()->findByPk($id)->delete();
        $this->redirect($this->createUrl("mff/default/index", array("parentid"=>$parentid)));
    }
    
    /// Создает новую свободную форму
    public function actionNew($parentid)
    {
        
    }
    
    /// Добавляет новое поле в свободной форме
    public function actionFieldNew($id, $name, $type, $description, $order, $parentid=null)
    {
        
    }
   
    /// Удаляет поле в свободной форме
     public function actionFieldDelete($id, $idfield, $parentid=null)
    {
        
    }

    /// Исправляет поле в свободной форме
     public function actionEditDelete($id, $idfield, $parentid=null)
    {
        
    }
    
}