<?php

/**
 * AuthForm class.
 * AuthForm is the data structure for keeping
 * user login form data. It is used by the 'login' action of 'AuthController'.
 */
class AuthForm extends CFormModel
{

	public $Signature;
//	public $CertSign;
//	public $CertCypher;

	private $_identity;

	/**
	 * Declares the validation rules.
	 * The rules state that username and password are required,
	 * and password needs to be authenticated.
	 */
	public function rules()
	{
		return array(
			// username and password are required
			array('Signature', 'required'),
			// password needs to be authenticated
			array('Signature', 'authenticate'),
		);
	}

	/**
	 * Declares attribute labels.
	 */
	public function attributeLabels()
	{
		return array(
//			'rememberMe'=>'Remember me next time',
		);
	}

	/**
	 * Authenticates the password.
	 * This is the 'authenticate' validator as declared in rules().
	 */
	public function authenticate($attribute,$params)
	{
		if(!$this->hasErrors())
		{
			error_log("AuthForm,authenticate,Signature:".$this->Signature);
			$this->_identity=new EUUserIdentity($this->Signature);
			if(!$this->_identity->authenticate())
				$this->addError('Signature','Incorrect Signature.');
		}
	}

	/**
	 * Logs in the user using the given username and password in the model.
	 * @return boolean whether login is successful
	 */
	public function login()
	{
error_log("AuthForm model login");
		if($this->_identity===null)
		{
			$this->_identity=new EUUserIdentity($this->Signature);
			$this->_identity->authenticate();
		}
		if($this->_identity->errorCode===EUUserIdentity::ERROR_NONE)
		{
			$duration=0; //$this->rememberMe ? 3600*24*30 : 0; // 30 days
			Yii::app()->user->login($this->_identity,$duration);
			return true;
		}
		else
			return false;
	}
}
