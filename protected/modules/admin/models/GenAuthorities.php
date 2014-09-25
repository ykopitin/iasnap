<?php

/**
 * This is the model class for table "gen_authorities".
 *
 * The followings are the available columns in table 'gen_authorities':
 * @property integer $id
 * @property string $is_cnap
 * @property string $type
 * @property string $name
 * @property integer $locations_id
 * @property string $index
 * @property string $street
 * @property string $building
 * @property string $office
 * @property string $working_time
 * @property string $phone
 * @property string $fax
 * @property string $email
 * @property string $web
 * @property string $transport
 * @property string $gpscoordinates
 * @property string $photo
 *
 * The followings are the available model relations:
 * @property CabAuthoritiesCerts[] $cabAuthoritiesCerts
 * @property CabUserInternal[] $cabUserInternals
 * @property GenLocations $locations
 * @property GenServices[] $genServices
 */
class GenAuthorities extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_authorities';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('is_cnap, type, name, locations_id, index, street, building, working_time, phone', 'required'),
			array('locations_id', 'numerical', 'integerOnly'=>true),
			array('is_cnap', 'length', 'max'=>8),
			array('type', 'length', 'max'=>16),
			array('name, transport, photo', 'length', 'max'=>255),
			array('working_time', 'length', 'max'=>1500),
			array('index, office', 'length', 'max'=>5),
			array('street', 'length', 'max'=>50),
			array('building', 'length', 'max'=>10),
			array('phone', 'length', 'max'=>44),
			array('fax', 'length', 'max'=>29),
			array('email, web', 'length', 'max'=>45),
			array('gpscoordinates', 'length', 'max'=>20),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, is_cnap, type, name, locations_id, index, street, building, office, working_time, phone, fax, email, web, transport, gpscoordinates, photo', 'safe', 'on'=>'search'),
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
			'cabAuthoritiesCerts' => array(self::HAS_MANY, 'CabAuthoritiesCerts', 'authorities_id'),
			'cabUserInternals' => array(self::HAS_MANY, 'CabUserInternal', 'authorities_id'),
			'locations' => array(self::BELONGS_TO, 'GenLocations', 'locations_id'),
			'genServices' => array(self::HAS_MANY, 'GenServices', 'subjnap_id'),
			'genServicesw' => array(self::HAS_MANY, 'GenServices', 'subjwork_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'is_cnap' => 'Тип обєкта',
			'type' => 'Приналежність',
			'name' => 'Назва органу',
			'locations_id' => 'ID населеного пункту',
			'index' => 'Індекс',
			'street' => 'Вулиця',
			'building' => 'Будинок №',
			'office' => 'Кабінет',
			'working_time' => 'Режим роботи',
			'phone' => 'Телефони',
			'fax' => 'Факс',
			'email' => 'Електронна скринька',
			'web' => 'Веб-сайт',
			'transport' => 'Міський транспорт',
			'gpscoordinates' => 'GPS координати (наприклад, 46.483723, 30.729476)',
			'photo' => 'Фотографія (посилання)',
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
		$criteria->compare('is_cnap',$this->is_cnap,true);
		$criteria->compare('type',$this->type,true);
		$criteria->compare('name',$this->name,true);
		$criteria->compare('locations_id',$this->locations_id);
		$criteria->compare('index',$this->index,true);
		$criteria->compare('street',$this->street,true);
		$criteria->compare('building',$this->building,true);
		$criteria->compare('office',$this->office,true);
		$criteria->compare('working_time',$this->working_time,true);
		$criteria->compare('phone',$this->phone,true);
		$criteria->compare('fax',$this->fax,true);
		$criteria->compare('email',$this->email,true);
		$criteria->compare('web',$this->web,true);
		$criteria->compare('transport',$this->transport,true);
		$criteria->compare('gpscoordinates',$this->gpscoordinates,true);
		$criteria->compare('photo',$this->photo,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenAuthorities the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
