<?php

/**
 * RegForm class.
 * RegForm is the data structure for keeping
 * user register form base data. It is used by the 'register' action of 'AuthController'.
 */
class RegForm extends CFormModel
{

	public $Signature;
	public $CertSign;
	public $CertCypher;
	public $Email;
	public $Email2;
	public $Phone;
	public $ConfirmPersonalData;
	public $SigData;

	private $_identity;

	/**
	 * Declares the validation rules.
	 * The rules state that username and password are required,
	 * and password needs to be authenticated.
	 */
	public function rules()
	{
	        Yii::import('ext.MyValidators.stringIsBase64');
		return array(
			array('Signature', 'required'),
			array('Signature', 'stringIsBase64'),
//			array('Signature', 'authenticate'),
//			array('Email', 'Email'),
        		// Почта должна быть в пределах от 6 до 50 символов
//        		array('Email', 'length', 'min'=>6, 'max'=>50),
        		// Почта должна быть уникальной
//        		array('Email', 'unique'),
        		// Почта должна быть написана в нижнем регистре
//        		array('Email', 'filter', 'filter'=>'mb_strtolower'),
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
	 * Logs in the user using the given username and password in the model.
	 * @return boolean whether login is successful
	 */
	public function verify_sign()
	{
error_log("RegForm,verify_sign");
		$this->SigData = new EUSignature($this->Signature);
		$er = $this->SigData->check();
error_log("RegForm,SignError:".$this->SigData->iErrorCode);
		if($this->SigData->iErrorCode!=0)
		{
			$this->addError('Signature', 'Помилка при перевірці ЕЦП');
			return false;
		}
		$SignedData = explode(";", $this->SigData->sResultData);
		$this->Email = $SignedData[0];
		$this->Email2 = $SignedData[1];
		$this->Phone = $SignedData[2];
		$this->CertSign = $SignedData[3];
		
error_log("RegForm,SignVer:".$this->SigData->sIssuer);
return true;

//		if($this->_identity->errorCode===EUUserIdentity::ERROR_NONE)
//		{
//			$duration=0; //$this->rememberMe ? 3600*24*30 : 0; // 30 days
//			Yii::app()->user->login($this->_identity,$duration);
//			return true;
//		}
//		else
//			return false;
	}
}
