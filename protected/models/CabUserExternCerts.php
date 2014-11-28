<?php

/**
 * This is the model class for table "cab_user_extern_certs".
 *
 * The followings are the available columns in table 'cab_user_extern_certs':
 * @property string $id
 * @property integer $type_of_user
 * @property string $certissuer
 * @property string $certserial
 * @property string $certSubjDRFOCode
 * @property string $certSubjEDRPOUCode
 * @property string $certData
 * @property integer $certType
 * @property string $ext_user_id
 * @property integer $certSignTime
 * @property integer $certUseTSP
 * @property string $certIssuerCN
 * @property string $certSubject
 * @property string $certSubjCN
 * @property string $certSubjOrg
 * @property string $certSubjOrgUnit
 * @property string $certSubjTitle
 * @property string $certSubjState
 * @property string $certSubjLocality
 * @property string $certSubjFullName
 * @property string $certSubjAddress
 * @property string $certSubjPhone
 * @property string $certSubjEMail
 * @property string $certSubjDNS
 * @property integer $certExpireBeginTime
 * @property integer $certExpireEndTime
 *
 * The followings are the available model relations:
 * @property CabUser $extUser
 */
class CabUserExternCerts extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'cab_user_extern_certs';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('type_of_user, certissuer, certserial, certType, ext_user_id', 'required'),
			array('type_of_user, certType, certSignTime, certUseTSP, certExpireBeginTime, certExpireEndTime', 'numerical', 'integerOnly'=>true),
			array('id, certSubjDRFOCode, certSubjEDRPOUCode, ext_user_id', 'length', 'max'=>10),
			array('certserial', 'length', 'max'=>40),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, type_of_user, certissuer, certserial, certSubjDRFOCode, certSubjEDRPOUCode, certData, certType, ext_user_id, certSignTime, certUseTSP, certIssuerCN, certSubject, certSubjCN, certSubjOrg, certSubjOrgUnit, certSubjTitle, certSubjState, certSubjLocality, certSubjFullName, certSubjAddress, certSubjPhone, certSubjEMail, certSubjDNS, certExpireBeginTime, certExpireEndTime', 'safe', 'on'=>'search'),
			array('certissuer', 'unique', 'criteria'=>array(
				'condition'=>'`certserial`=:secondKey',
				'params'=>array(
					':secondKey'=>$this->certserial
				)
			)),
			
		);
	}

	/**
	 * @return array relational rules.
	 */
	public function relations()
	{
		// NOTE: you may need to adjust the relation name and the related
		// class name for the relations automatically generated below.
		return array(
			'extUser' => array(self::BELONGS_TO, 'CabUser', 'ext_user_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'type_of_user' => 'Сертифікат особи', // (0-фіз.особа 1-юридична)',
			'certissuer' => 'Ім\'я видавця сертифікату',
			'certserial' => 'Серійний номер сертифікату',
			'certSubjDRFOCode' => 'Код ДРФО',
			'certSubjEDRPOUCode' => 'Код ЄДРПОУ',
			'certData' => 'Вміст сертифікату',
			'certType' => 'Тип ЕЦП/шифрування',
			'ext_user_id' => 'ID зовнішнього користувача',
			
			'certSignTime' => 'Час підпису форми реєстрації',
			'certUseTSP' => 'Присутність мітки часу',
			'certIssuerCN' => 'Загальне ім\'я видавника',
			'certSubject' => 'Власник сертифікату',
			'certSubjCN' => 'Загальне ім\'я власника',
			'certSubjOrg' => 'Організація',
			'certSubjOrgUnit' => 'Підрозділ',
			'certSubjTitle' => 'Посада',
			'certSubjState' => 'Область',
			'certSubjLocality' => 'Місто',
			'certSubjFullName' => 'Повне ім\'я',
			'certSubjAddress' => 'Адреса',
			'certSubjPhone' => 'Телефон',
			'certSubjEMail' => 'E-Mail',
			'certSubjDNS' => 'DNS',
			'certExpireBeginTime' => 'Дата початку дії сертифікату',
			'certExpireEndTime' => 'Дата закінчення дії сертифікату',
		);
	}

	/**
	 * Retrieves a list of models based on the current search/filter conditions.
	 *
	 * Typical usecase:
	 * - Initialize the model fields with values from filter form.
	 * - Execute this method to get CActiveDataProvider instance which will filter
	 * models according to data in model fields.
	 * - Pass data provider to CGridView, CListView or any similar widget.
	 *
	 * @return CActiveDataProvider the data provider that can return the models
	 * based on the search/filter conditions.
	 */
	public function search()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id,true);
		$criteria->compare('type_of_user',$this->type_of_user);
		$criteria->compare('certissuer',$this->certissuer,true);
		$criteria->compare('certserial',$this->certserial,true);
		$criteria->compare('certSubjDRFOCode',$this->certSubjDRFOCode,true);
		$criteria->compare('certSubjEDRPOUCode',$this->certSubjEDRPOUCode,true);
		$criteria->compare('certData',$this->certData,true);
		$criteria->compare('certType',$this->certType);
		$criteria->compare('ext_user_id',$this->ext_user_id,true);
		$criteria->compare('certSignTime',$this->certSignTime);
		$criteria->compare('certUseTSP',$this->certUseTSP);
		$criteria->compare('certIssuerCN',$this->certIssuerCN,true);
		$criteria->compare('certSubject',$this->certSubject,true);
		$criteria->compare('certSubjCN',$this->certSubjCN,true);
		$criteria->compare('certSubjOrg',$this->certSubjOrg,true);
		$criteria->compare('certSubjOrgUnit',$this->certSubjOrgUnit,true);
		$criteria->compare('certSubjTitle',$this->certSubjTitle,true);
		$criteria->compare('certSubjState',$this->certSubjState,true);
		$criteria->compare('certSubjLocality',$this->certSubjLocality,true);
		$criteria->compare('certSubjFullName',$this->certSubjFullName,true);
		$criteria->compare('certSubjAddress',$this->certSubjAddress,true);
		$criteria->compare('certSubjPhone',$this->certSubjPhone,true);
		$criteria->compare('certSubjEMail',$this->certSubjEMail,true);
		$criteria->compare('certSubjDNS',$this->certSubjDNS,true);
		$criteria->compare('certExpireBeginTime',$this->certExpireBeginTime);
		$criteria->compare('certExpireEndTime',$this->certExpireEndTime);
		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserExternCerts the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
