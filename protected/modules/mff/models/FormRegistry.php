<?php

/**
 * This is the model class for table "form_registry".
 *
 * The followings are the available columns in table 'form_registry':
 * @property integer $id
 * @property integer $parent
 * @property string $tablename
 * @property string $description
 * @property integer $protected
 *
 * The followings are the available model relations:
 * @property FormDefault[] $formDefaults
 * @property FormField[] $formFields
 */
class FormRegistry extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'form_registry';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('tablename', 'required'),
			array('parent, protected', 'numerical', 'integerOnly'=>true),
			array('tablename', 'length', 'max'=>45),
			array('description', 'safe'),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, parent, tablename, description, protected', 'safe', 'on'=>'search'),
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
			'formDefaults' => array(self::HAS_MANY, 'FormDefault', 'registry'),
			'formFields' => array(self::HAS_MANY, 'FormField', 'formid'),
                        'parentItem' => array(self::HAS_ONE, 'FormRegistry', 'parent'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'parent' => 'ссылка на родителя',
			'tablename' => 'Имя таблицы в которая используется для хранения данных свободной формы',
			'description' => 'описание',
			'protected' => 'Блокировка/ системная таблица',
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
		$criteria->compare('parent',$this->parent);
		$criteria->compare('tablename',$this->tablename,true);
		$criteria->compare('description',$this->description,true);
		$criteria->compare('protected',$this->protected);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return FormRegistry the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
