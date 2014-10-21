<?php

/**
 * This is the model class for table "form_storage".
 *
 * The followings are the available columns in table 'form_storage':
 * @property integer $id
 * @property string $name
 *
 * The followings are the available model relations:
 * @property FormDefault[] $formDefaults
 */
class FFStorage extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'ff_storage';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('name', 'required'),
                        array('subtype, type', 'numerical', 'integerOnly'=>true),
                        array('name', 'length', 'max'=>255),
                        array('description', 'safe'),

                        array('id, name, description, subtype, type', 'safe', 'on'=>'search'),
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
			'records' => array(self::HAS_MANY, 'fieldlist_FFModel', 'storage'),
			'typeItem' => array(self::BELONGS_TO, 'FFType', 'type'),
                        'registryItems' => array(self::MANY_MANY, 'FFRegistry', 'ff_registry_storage(storage, registry)'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'name' => 'Имя хранилища',
			'description' => 'Описание',
                        'subtype' => 'Подтип',
                        'type' => 'Тип данных',
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
		$criteria->compare('name',$this->name,true);
		$criteria->compare('description',$this->description,true);
		$criteria->compare('subtype',$this->subtype);
		$criteria->compare('type',$this->type);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return FormStorage the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
        

}
