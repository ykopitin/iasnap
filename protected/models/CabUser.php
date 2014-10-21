<?php

/**
 * This is the model class for table "cab_user_external".
 *
 * The followings are the available columns in table 'cab_user_external':
 * @property string $id
 * @property integer $type_of_user
 * @property string $email
 * @property string $phone
 * @property string $cab_state
 *
 * The followings are the available model relations:
 * @property CabOrgExternalCerts[] $cabOrgExternalCerts
 * @property CabUserBidsConnect[] $cabUserBidsConnects
 * @property CabUserExternCerts[] $cabUserExternCerts
 */
class CabUser extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'cab_user';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('type_of_user, email, phone, cab_state', 'required'),
//			array('type_of_user, email, phone', 'required'),
			array('type_of_user', 'numerical', 'integerOnly'=>true),
			array('id', 'length', 'max'=>10),
			array('email', 'length', 'max'=>45),
			array('email', 'email'),
			array('phone', 'length', 'max'=>12),
			array('cab_state', 'length', 'max'=>27),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, type_of_user, email, phone, cab_state', 'safe', 'on'=>'search'),
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
			'cabOrgExternalCerts' => array(self::HAS_MANY, 'CabOrgExternalCerts', 'ext_user_id'),
			'cabUserBidsConnects' => array(self::HAS_MANY, 'CabUserBidsConnect', 'user_id'),
			'cabUserExternCerts' => array(self::HAS_MANY, 'CabUserExternCerts', 'ext_user_id'),
			'cabUserAuthorityId' => array(self::BELONGS_TO, 'GenAuthorities', 'authorities_id'),
			'cabUserRole' => array(self::BELONGS_TO, 'CabUserRoles', 'user_roles_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'type_of_user' => 'Тип користувача (0-фіз.особа, 1- ФОП, 2-юр.особа)',
			'email' => 'Електронна поштова скринька',
			'phone' => 'Мобільний телефон',
			'cab_state' => 'стан кабінету',
			'authorities_id' => 'ID місця надання послуг',
			'user_roles_id' => 'Роль користувача (0-адм.безп., 1-сист.адм., 2-адм.ЦНАП, 3-оп.НАП, 4-суб.зверн.)',
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
	public function searchext()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id,true);
		$criteria->compare('type_of_user',$this->type_of_user);
		$criteria->compare('email',$this->email,true);
		$criteria->compare('phone',$this->phone,true);
		$criteria->compare('cab_state',$this->cab_state,true);
		$criteria->compare('authorities_id',$this->authorities_id,true);
//		$criteria->compare('user_roles_id',$this->user_roles_id,true);
		$criteria->compare('user_roles_id','4',true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	public function searchint()
	{
		// @todo Please modify the following code to remove attributes that should not be searched.

		$criteria=new CDbCriteria;

		$criteria->compare('id',$this->id,true);
		$criteria->compare('type_of_user',$this->type_of_user);
		$criteria->compare('email',$this->email,true);
		$criteria->compare('phone',$this->phone,true);
		$criteria->compare('cab_state',$this->cab_state,true);
		$criteria->compare('authorities_id',$this->authorities_id,true);
//		$criteria->compare('user_roles_id',$this->user_roles_id,true);
		$criteria->compare('user_roles_id','<4',true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return CabUserExternal the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
