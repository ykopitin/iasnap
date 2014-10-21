<?php

/**
 * This is the model class for table "gen_locations".
 *
 * The followings are the available columns in table 'gen_locations':
 * @property integer $id
 * @property string $type
 * @property string $name
 *
 * The followings are the available model relations:
 * @property GenAuthorities[] $genAuthorities
 */
class GenLocations extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_locations';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('type, name', 'required'),
			array('type', 'length', 'max'=>12),
			array('name', 'length', 'max'=>50),
			//array('type', 'in', 'range' => array('1','2','3')),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, type, name', 'safe', 'on'=>'search'),
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
			'genAuthorities' => array(self::HAS_MANY, 'GenAuthorities', 'locations_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'type' => 'Тип населеного пункту',
			'name' => 'Назва населеного пункту',
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
		$criteria->compare('type',$this->type,true);
		$criteria->compare('name',$this->name,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
		 
	/*	
		$users=GenLocations::model()->with(array(
        'genAuthorities'=>array(
        'select'=>array('locations.id'),
        'joinType'=>'INNER JOIN',
        ),
        ))->findAll();

	    return new CActiveDataProvider($this, array(
        'data'=>$users,
        ));
		*/
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenLocations the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
