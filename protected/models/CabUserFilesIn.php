<?php

/**
 * This is the model class for table "cab_user_files_in".
 *
 * The followings are the available columns in table 'cab_user_files_in':
 * @property integer $id
 * @property string $user_bid_id
 * @property string $content
 * @property string $extension
 * @property integer $state
 * @property string $date
 *
 * The followings are the available model relations:
 * @property GenBidCurrentStatus $userBid
 */
class CabUserFilesIn extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'cab_user_files_in';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('user_bid_id, content, extension, state, date', 'required'),
			array('state', 'numerical', 'integerOnly'=>true),
			array('user_bid_id', 'length', 'max'=>11),
			array('extension', 'length', 'max'=>5),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, user_bid_id, content, extension, state, date', 'safe', 'on'=>'search'),
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
			'userBid' => array(self::BELONGS_TO, 'GenBidCurrentStatus', 'user_bid_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'user_bid_id' => 'User Bid',
			'content' => 'Content',
			'extension' => 'Extension',
			'state' => 'State',
			'date' => 'Date',
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

		$criteria->compare('id',$this->id);
		$criteria->compare('user_bid_id',$this->user_bid_id,true);
		$criteria->compare('content',$this->content,true);
		$criteria->compare('extension',$this->extension,true);
		$criteria->compare('state',$this->state);
		$criteria->compare('date',$this->date,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserFilesIn the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
