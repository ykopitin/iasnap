<?php

/**
 * AuthForm class.
 * AuthForm is the data structure for keeping
 * user login form data. It is used by the 'login' action of 'AuthController'.
 */
class PrivatForm extends CFormModel
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
		//	array('Signature', 'authenticate'),
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


}
