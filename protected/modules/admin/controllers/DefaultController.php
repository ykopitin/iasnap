<?php

class DefaultController extends Controller
{
		public function filters()
	{
		return array(
			'accessControl', // perform access control for CRUD operations
			'postOnly + delete', // we only allow deletion via POST request
		);
	}
	
	public function accessRules()
	{
		return array(
			array('allow', // allow authenticated user to perform 'create' and 'update' actions
				'actions'=>array('index','id1','id2','id3','id4'),
				'users'=>array('@'),
			),
			array('deny',  // deny all users
				'users'=>array('*'),
			),
		);
	}
	
	public function getMenuItems($id) {
   
   $criteria=new CDbCriteria;
   $criteria->condition='par_id=:par_id';
   $criteria->params=array(':par_id'=>$id);
   $criteria->order='ref ASC';
   $dbQuery=CabAdmMenu::model()->findAll($criteria); 
   
   
   $menuItems = array();

   foreach($dbQuery as $item) {
   //   $z=Yii::app()->createUrl($item->url);
	  $menuItems[] = array('label'=>$item->name, 'url'=>Yii::app()->createUrl($item->url));
   }
   return $menuItems;
   }
	public function actionIndex()
	{
		$idis=0;
		$this->layout='//layouts/column1';
		$this->render('index',array('idis'=>$idis));
	}
	
	public function actionId1()
	{
		
		$idis=1;
		$hname="Управління загальним інтерфейсом порталу";
		$this->layout='//layouts/column1';
		$this->render('menus',array('hname'=>$hname,'idis'=>$idis));
	}
	
	public function actionId2()
	{
		$idis=2;
		$hname="Управління послугами";
		$this->layout='//layouts/column1';
		$this->render('menus',array('hname'=>$hname,'idis'=>$idis));
	}
	
	public function actionId3()
	{
		$idis=3;
		$hname="Управління користувачами";
		$this->layout='//layouts/column1';
		$this->render('menus',array('hname'=>$hname,'idis'=>$idis));
	}
	
	public function actionId4()
	{
		$idis=4;
		$hname="Управління довідниками";
		$this->layout='//layouts/column1';
		$this->render('menus',array('hname'=>$hname,'idis'=>$idis));
	}
}