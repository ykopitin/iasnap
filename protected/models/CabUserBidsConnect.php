<?php

/**
 * This is the model class for table "cab_user_bids_connect".
 *
 * The followings are the available columns in table 'cab_user_bids_connect':
 * @property string $id
 * @property string $user_id
 * @property string $bid_created_date
 * @property integer $services_id
 * @property string $payment_status
 * @property integer $answer_variant
 * @property string $address
 *
 * The followings are the available model relations:
 * @property GenBidCurrentStatus $id0
 * @property GenServices $services
 * @property CabUserExternal $user
 */
class CabUserBidsConnect extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'cab_user_bids_connect';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('user_id, bid_created_date, services_id, payment_status, answer_variant', 'required'),
			array('services_id, answer_variant', 'numerical', 'integerOnly'=>true),
			array('user_id', 'length', 'max'=>10),
			array('payment_status', 'length', 'max'=>6),
			array('address', 'length', 'max'=>255),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, user_id, bid_created_date, services_id, payment_status, answer_variant, address', 'safe', 'on'=>'search'),
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
			'id0' => array(self::BELONGS_TO, 'GenBidCurrentStatus', 'id'),
			'services' => array(self::BELONGS_TO, 'GenServices', 'services_id'),
			'user' => array(self::BELONGS_TO, 'CabUserExternal', 'user_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'user_id' => 'User',
			'bid_created_date' => 'Bid Created Date',
			'services_id' => 'Services',
			'payment_status' => 'Payment Status',
			'answer_variant' => 'Answer Variant',
			'address' => 'Address',
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
		$criteria->compare('user_id',$this->user_id,true);
		$criteria->compare('bid_created_date',$this->bid_created_date,true);
		$criteria->compare('services_id',$this->services_id);
		$criteria->compare('payment_status',$this->payment_status,true);
		$criteria->compare('answer_variant',$this->answer_variant);
		$criteria->compare('address',$this->address,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserBidsConnect the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
