<?php

class CabUserController extends Controller
{
	/**
	 * @var string the default layout for the views. Defaults to '//layouts/column2', meaning
	 * using two-column layout. See 'protected/views/layouts/column2.php'.
	 */
	public $layout='//layouts/column1';

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
//			array('allow',  // allow all users to perform 'index' and 'view' actions
//				'actions'=>array('index','view'),
//				'users'=>array('@'),
//			),
//			array('allow', // allow authenticated user to perform 'create' and 'update' actions
//				'actions'=>array('create','createint','update'),
//				'users'=>array('@'),
//			),
			array('allow', // allow admin user to perform 'admin' and 'delete' actions
				'actions'=>array('index','view','admin','adminint','create','createint','update','delete'),
//				'users'=>array('admin'),
				'expression' => "Yii::app()->user->checkAccess('siteadmin')||Yii::app()->user->id=='admin'",
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
		
//	    if(Yii::app()->user->checkAccess('siteadmin')) {
//		$this->render('view',array(
//			'model'=>$this->loadModel($id),
//		));
//	    } else echo "DENIED";
	}

	/**
	 * Creates a new model (external user).
	 * If creation is successful, the browser will be redirected to the 'view' page.
	 */
	public function actionCreate()
	{
		$model=new CabUser;

		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if(isset($_POST['CabUser']))
		{
			$model->attributes=$_POST['CabUser'];
			$model->user_roles_id=4;
			if($model->save())
				$this->redirect(array('view','id'=>$model->id));
		}

		$this->render('create',array(
			'model'=>$model,
		));
	}

	public function actionCreateint()
	{
		$model=new CabUser;
		$model->type_of_user=0;
		$model->cab_state="не активований";
		$model->time_registered = time();
		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if(isset($_POST['CabUser']))
		{
			$model->attributes=$_POST['CabUser'];

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

		if(isset($_POST['CabUser']))
		{
			$model->attributes=$_POST['CabUser'];
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
		$dataProvider=new CActiveDataProvider('CabUser');
		$this->render('index',array(
			'dataProvider'=>$dataProvider,
		));
	}

	/**
	 * Manages external users.
	 */
	public function actionAdmin()
	{
		$model=new CabUser('search');
		$model->unsetAttributes();  // clear any default values
		if(isset($_GET['CabUser']))
			$model->attributes=$_GET['CabUser'];

		$this->render('admin',array(
			'model'=>$model,
		));
	}

	/**
	 * Manages internal users.
	 */
	public function actionAdminint()
	{
	  if (Yii::app()->user->checkAccess('siteadmin') || Yii::app()->user->id == 'admin'){
		$model=new CabUser('search');
		$model->unsetAttributes();  // clear any default values
		if(isset($_GET['CabUser']))
			$model->attributes=$_GET['CabUser'];

		$this->render('adminint',array(
			'model'=>$model,
		));
	  }
	}




	/**
	 * Returns the data model based on the primary key given in the GET variable.
	 * If the data model is not found, an HTTP exception will be raised.
	 * @param integer $id the ID of the model to be loaded
	 * @return CabUser the loaded model
	 * @throws CHttpException
	 */
	public function loadModel($id)
	{
		$model=CabUser::model()->findByPk($id);
		if($model===null)
			throw new CHttpException(404,'The requested page does not exist.');
		return $model;
	}

	/**
	 * Performs the AJAX validation.
	 * @param CabUser $model the model to be validated
	 */
	protected function performAjaxValidation($model)
	{
		if(isset($_POST['ajax']) && $_POST['ajax']==='cab-user-form')
		{
			echo CActiveForm::validate($model);
			Yii::app()->end();
		}
	}
}
