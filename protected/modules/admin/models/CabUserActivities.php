<?php

/**
 * This is the model class for table "cab_user_activities".
 *
 * The followings are the available columns in table 'cab_user_activities':
 * @property string $id
 * @property integer $portal_user_id
 * @property string $visiting
 * @property string $IPAdress
 * @property string $type
 * @property integer $success
 */
class CabUserActivities extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'cab_user_activities';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('id, portal_user_id, visiting, IPAdress, type, success', 'required'),
			array('portal_user_id, success', 'numerical', 'integerOnly'=>true),
			array('id', 'length', 'max'=>10),
			array('IPAdress', 'length', 'max'=>15),
			array('type', 'length', 'max'=>26),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, portal_user_id, visiting, IPAdress, type, success', 'safe', 'on'=>'search'),
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
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'portal_user_id' => 'ID користувача',
			'visiting' => 'Час події',
			'IPAdress' => 'IP адреса',
			'type' => 'Подія',
			'success' => 'Успішність 0/1',
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
		$criteria->compare('portal_user_id',$this->portal_user_id);
		$criteria->compare('visiting',$this->visiting,true);
		$criteria->compare('IPAdress',$this->IPAdress,true);
		$criteria->compare('type',$this->type,true);
		$criteria->compare('success',$this->success);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserActivities the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
