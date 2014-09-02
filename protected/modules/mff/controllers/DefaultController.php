<?php

class DefaultController extends Controller
{
    public $layout='//layouts/column2';
    //public $defaultAction='listforms';
    
    public function actionIndex($parentid=null)
    {        
        $this->render('listforms',array("parentid"=>$parentid));
    }

    public function actionEdit($id,$parentid=null)
    {
        $this->render("listforms", array("parentid"=>$parentid,"id"=>$id));
    }
}