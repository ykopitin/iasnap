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
				'actions'=>array('index'),
				'users'=>array('@'),
			),
			array('deny',  // deny all users
				'users'=>array('*'),
			),
		);
	}
	

	public function actionIndex()
	{
		//$idis=0;
		//$this->layout='//layouts/column1';
		//$this->render('index',array('idis'=>$idis));
		$this->redirect(array('/admin/genServices/admin'));
	}
	
}