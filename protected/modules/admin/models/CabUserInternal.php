<?php

/**
 * This is the model class for table "cab_user_internal".
 *
 * The followings are the available columns in table 'cab_user_internal':
 * @property integer $id
 * @property integer $authorities_id
 * @property integer $user_roles_id
 * @property string $cab_state
 *
 * The followings are the available model relations:
 * @property CabUserInternCerts[] $cabUserInternCerts
 * @property GenAuthorities $authorities
 * @property CabUserRoles $userRoles
 */
class CabUserInternal extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'cab_user_internal';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('id, authorities_id, user_roles_id, cab_state', 'required'),
			array('id, authorities_id, user_roles_id', 'numerical', 'integerOnly'=>true),
			array('cab_state', 'length', 'max'=>22),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, authorities_id, user_roles_id, cab_state', 'safe', 'on'=>'search'),
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
			'cabUserInternCerts' => array(self::HAS_MANY, 'CabUserInternCerts', 'int_user_id'),
			'authorities' => array(self::BELONGS_TO, 'GenAuthorities', 'authorities_id'),
			'userRoles' => array(self::BELONGS_TO, 'CabUserRoles', 'user_roles_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'authorities_id' => 'ID органу',
			'user_roles_id' => 'ID ролі користувача',
			'cab_state' => 'стан кабінету',
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
		$criteria->compare('authorities_id',$this->authorities_id);
		$criteria->compare('user_roles_id',$this->user_roles_id);
		$criteria->compare('cab_state',$this->cab_state,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserInternal the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
