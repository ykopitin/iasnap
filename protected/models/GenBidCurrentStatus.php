<?php

/**
 * This is the model class for table "gen_bid_current_status".
 *
 * The followings are the available columns in table 'gen_bid_current_status':
 * @property string $id
 * @property string $bid_id
 * @property integer $status_id
 * @property string $date_of_change
 *
 * The followings are the available model relations:
 * @property CabBidsRkk $cabBidsRkk
 * @property CabUserBidsConnect $cabUserBidsConnect
 * @property CabUserFilesIn[] $cabUserFilesIns
 * @property CabUserFilesOut[] $cabUserFilesOuts
 */
class GenBidCurrentStatus extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_bid_current_status';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('bid_id, status_id, date_of_change', 'required'),
			array('status_id', 'numerical', 'integerOnly'=>true),
			array('bid_id', 'length', 'max'=>11),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, bid_id, status_id, date_of_change', 'safe', 'on'=>'search'),
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
			'cabBidsRkk' => array(self::HAS_ONE, 'CabBidsRkk', 'id'),
			'cabUserBidsConnect' => array(self::HAS_ONE, 'CabUserBidsConnect', 'id'),
			'cabUserFilesIns' => array(self::HAS_MANY, 'CabUserFilesIn', 'user_bid_id'),
			'cabUserFilesOuts' => array(self::HAS_MANY, 'CabUserFilesOut', 'user_bid_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'bid_id' => 'Bid',
			'status_id' => 'Status',
			'date_of_change' => 'Date Of Change',
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
		$criteria->compare('bid_id',$this->bid_id,true);
		$criteria->compare('status_id',$this->status_id);
		$criteria->compare('date_of_change',$this->date_of_change,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenBidCurrentStatus the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
