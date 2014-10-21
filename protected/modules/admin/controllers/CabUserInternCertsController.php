<?php

class CabUserInternCertsController extends Controller
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
			array('allow', // allow authenticated user to perform 'create' and 'update' actions
				'actions'=>array('index','view','create','update'),
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
		$model=new CabUserInternCerts;

		// Uncomment the following line if AJAX validation is needed
		// $this->performAjaxValidation($model);

		if(isset($_POST['CabUserInternCerts']))
		{
			$model->attributes=$_POST['CabUserInternCerts'];
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

		if(isset($_POST['CabUserInternCerts']))
		{
			$model->attributes=$_POST['CabUserInternCerts'];
			if($model->save()) {
				if (isset($_POST['CabUserInternCerts']['new_user'])){
				    $new_user = $_POST['CabUserInternCerts']['new_user'];
				    if (is_numeric($new_user)) {
					$user_model = CabUser::model()->findByPk($new_user);
					if($user_model===null)
						throw new CHttpException(404,'Задана сторінка не знайдена.');
					$user_model_cert = new CabUserExternCerts();
					$user_model_cert->type_of_user = $user_model->type_of_user;
					$user_model_cert->certissuer = $model->certissuer;
					$user_model_cert->certserial = $model->certserial;
					$user_model_cert->certSubjDRFOCode = $model->certSubjDRFOCode;
					$user_model_cert->certSubjEDRPOUCode = $model->certSubjEDRPOUCode;
					$user_model_cert->certType = $model->certType;
					$user_model_cert->certData = $model->certData;
//error_log("reg006 CertSign:".$user_model_cert->certData);
					$user_model_cert->ext_user_id = $user_model->id;
//error_log("reg007");
					if($user_model_cert->validate()){
						$user_model_cert->save();
						$model->delete();
						$this->redirect(array('/admin/CabUser/update', 'id'=>$user_model_cert->ext_user_id));
					}else{
						print_r($user_model_cert->getErrors());
						Yii::app()->end();
					}
					
				    }
				}
				$this->redirect(array('view','id'=>$model->id));
			}
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
		$dataProvider=new CActiveDataProvider('CabUserInternCerts');
		$this->render('index',array(
			'dataProvider'=>$dataProvider,
		));
	}

	/**
	 * Manages all models.
	 */
	public function actionAdmin()
	{
		$model=new CabUserInternCerts('search');
		$model->unsetAttributes();  // clear any default values
		if(isset($_GET['CabUserInternCerts']))
			$model->attributes=$_GET['CabUserInternCerts'];

		$this->render('admin',array(
			'model'=>$model,
		));
	}

	/**
	 * Returns the data model based on the primary key given in the GET variable.
	 * If the data model is not found, an HTTP exception will be raised.
	 * @param integer $id the ID of the model to be loaded
	 * @return CabUserInternCerts the loaded model
	 * @throws CHttpException
	 */
	public function loadModel($id)
	{
		$model=CabUserInternCerts::model()->findByPk($id);
		if($model===null)
			throw new CHttpException(404,'The requested page does not exist.');
		return $model;
	}

	/**
	 * Performs the AJAX validation.
	 * @param CabUserInternCerts $model the model to be validated
	 */
	protected function performAjaxValidation($model)
	{
		if(isset($_POST['ajax']) && $_POST['ajax']==='cab-user-intern-certs-form')
		{
			echo CActiveForm::validate($model);
			Yii::app()->end();
		}
	}
}
