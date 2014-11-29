<?php

class PrivatController extends Controller
{
	/**
	 * @var string the default layout for the views. Defaults to '//layouts/column2', meaning
	 * using two-column layout. See 'protected/views/layouts/column2.php'.
	 */
	public $layout='//layouts/column2';

	/**
	 * @return array action filters
	 */
	public function filters()
	{
		return array(
			'accessControl', // perform access control for CRUD operations
			'postOnly + delete', // we only allow deletion via POST request
		);
	}

	/**
	 * Specifies the access control rules.
	 * This method is used by the 'accessControl' filter.
	 * @return array access control rules
	 */
	public function accessRules()
	{
		return array(
			array('allow',  // allow all users to perform 'index' and 'view' actions
				'actions'=>array('index','view','pay'),
				'users'=>array('*'),
			),
			array('allow', // allow authenticated user to perform 'create' and 'update' actions
				'actions'=>array('create','update'),
				'users'=>array('@'),
			),
			array('allow', // allow admin user to perform 'admin' and 'delete' actions
				'actions'=>array('admin','delete'),
				'users'=>array('admin'),
			),
			array('deny',  // deny all users
				'users'=>array('*'),
			),
		);
	}

	/**
	 * Displays a particular model.
	 * @param integer $id the ID of the model to be displayed
	 */
	public function actionView($id)
	{
		$this->render('view',array(
			'model'=>$this->loadModel($id),
		));
	}

	/**
	 * Creates a new model.
	 * If creation is successful, the browser will be redirected to the 'view' page.
	 */
	public function actionCreate()
	{
		$model=new GenServCatClass;

		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if(isset($_POST['GenServCatClass']))
		{
			$model->attributes=$_POST['GenServCatClass'];
			if($model->save())
				$this->redirect(array('view','id'=>$model->id));
		}

		$this->render('create',array(
			'model'=>$model,
		));
	}

	/**
	 * Updates a particular model.
	 * If update is successful, the browser will be redirected to the 'view' page.
	 * @param integer $id the ID of the model to be updated
	 */
	public function actionUpdate($id)
	{
		$model=$this->loadModel($id);

		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if(isset($_POST['GenServCatClass']))
		{
			$model->attributes=$_POST['GenServCatClass'];
			if($model->save())
				$this->redirect(array('view','id'=>$model->id));
		}

		$this->render('update',array(
			'model'=>$model,
		));
	}

	/**
	 * Deletes a particular model.
	 * If deletion is successful, the browser will be redirected to the 'admin' page.
	 * @param integer $id the ID of the model to be deleted
	 */
	public function actionDelete($id)
	{
		$this->loadModel($id)->delete();

		// if AJAX request (triggered by deletion via admin grid view), we should not redirect the browser
		if(!isset($_GET['ajax']))
			$this->redirect(isset($_POST['returnUrl']) ? $_POST['returnUrl'] : array('admin'));
	}

	/**
	 * Lists all models.
	 */
	public function actionIndex()
	{
		//$dataProvider=new CActiveDataProvider('GenServCatClass');
		$this->render('index');
	}
	public function actionPay()
	{
		
		//$dataProvider=new CActiveDataProvider('GenServCatClass');
		//include(require_once);
		//require_once( dirname(__FILE__) . '/../components/p24api.php');
		require_once( dirname(__FILE__) . '/../components/LiqPay.php');
		$public_key='i6289354858';
        $private_key='KvsOs9MOzY2qfE1aYDWu8RxgqnT88UjVSK6WnLZK';
		$liqpay = new LiqPay($public_key, $private_key);
        $res = $liqpay->api("payment/status", array(
        'order_id'       => 'sdsw'
        ));
		var_dump($res);
		//$dom = new DomDocument('1.0','UTF-8');
		//$dom->loadXML('<info>1</info>');
		//echo $dom->info;
		//exit;
	//	echo $payment->merid;
	//	$e=serialize($_POST);
	//    error_log($e);
		/*if(isset($_POST['PaySubm'])){
		$payment=new p24api("104221","K93CBfE3g492O7gQ5z5NKJTZf823h0GB","https://api.privatbank.ua/p24api/pay_pb");
		echo $payment->sendPrpRequest();
		$payments=array();
		$payments[] = array('id'=>'','b_card_or_acc'=>'5168755377643917','amt'=>'1','ccy'=>'UAH','details'=>'TestTestovich');
		$result = $payment->sendCmtRequest($payments, 90, 1);
		var_dump($result);
		//var_dump($_POST);
		}*/
	//	$this->render('pay');
	}
	/**
	 * Manages all models.
	 */
	public function actionAdmin()
	{
		$model=new GenServCatClass('search');
		$model->unsetAttributes();  // clear any default values
		if(isset($_GET['GenServCatClass']))
			$model->attributes=$_GET['GenServCatClass'];

		$this->render('admin',array(
			'model'=>$model,
		));
	}

	/**
	 * Returns the data model based on the primary key given in the GET variable.
	 * If the data model is not found, an HTTP exception will be raised.
	 * @param integer $id the ID of the model to be loaded
	 * @return GenServCatClass the loaded model
	 * @throws CHttpException
	 */
	public function loadModel($id)
	{
		$model=GenServCatClass::model()->findByPk($id);
		if($model===null)
			throw new CHttpException(404,'The requested page does not exist.');
		return $model;
	}

	/**
	 * Performs the AJAX validation.
	 * @param GenServCatClass $model the model to be validated
	 */
	protected function performAjaxValidation($model)
	{
		if(isset($_POST['ajax']) && $_POST['ajax']==='gen-serv-cat-class-form')
		{
			echo CActiveForm::validate($model);
			Yii::app()->end();
		}
	}
}
