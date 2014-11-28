<?php

/**
 * This is the model class for table "cab_user_intern_certs".
 *
 * The followings are the available columns in table 'cab_user_intern_certs':
 * @property string $id
 * @property string $certissuer
 * @property string $certserial
 * @property string $certSubjDRFOCode
 * @property string $certSubjEDRPOUCode
 * @property string $certData
 * @property integer $certType
 * @property integer $signedData
 *
 * The followings are the available model relations:
 * @property CabUserInternal $intUser
 */
class CabUserInternCerts extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */

	public $new_user;

	public function tableName()
	{
		return 'cab_user_intern_certs';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('certissuer, certserial, certData, certType', 'required'),
			array('certType', 'numerical', 'integerOnly'=>true),
			array('id, certSubjDRFOCode, certSubjEDRPOUCode', 'length', 'max'=>10),
			array('certserial', 'length', 'max'=>40),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, certissuer, certserial, certSubjDRFOCode, certSubjEDRPOUCode, certData, certType, signedData', 'safe', 'on'=>'search'),
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
//			'intUser' => array(self::BELONGS_TO, 'CabUserInternal', 'int_user_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'certissuer' => 'Ім\'я видавця сертифікату',
			'certserial' => 'Серійний номер сертифікату',
			'certSubjDRFOCode' => 'Код ДРФО',
			'certSubjEDRPOUCode' => 'Код ЄДРПОУ',
			'certData' => 'Вміст сертифікату',
			'certType' => 'Тип ЕЦП/шифрування',
			'signedData' => 'Підписані дані',
			'new_user' => "Прив'язка до ID користувача",
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
		$criteria->compare('certissuer',$this->certissuer,true);
		$criteria->compare('certserial',$this->certserial,true);
		$criteria->compare('certSubjDRFOCode',$this->certSubjDRFOCode,true);
		$criteria->compare('certSubjEDRPOUCode',$this->certSubjEDRPOUCode,true);
//		$criteria->compare('certData',$this->certData,true);
		$criteria->compare('certType',$this->certType);
		$criteria->compare('signedData',$this->signedData);
		$criteria->compare('new_user',$this->new_user);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserInternCerts the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
