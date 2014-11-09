<?php

/**
 * This is the model class for table "gen_life_situation".
 *
 * The followings are the available columns in table 'gen_life_situation':
 * @property integer $id
 * @property string $name
 * @property string $visability
 * @property string $icon
 *
 * The followings are the available model relations:
 * @property GenServices[] $genServices
 */
class GenLifeSituation extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_life_situation';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('name, visability, icon', 'required'),
			array('name', 'length', 'max'=>100),
			array('name','unique','message'=>'{attribute}:{value} вже існує у базі даних!'),
			array('visability', 'length', 'max'=>6),
			array('icon', 'length', 'max'=>255),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, name, visability, icon', 'safe', 'on'=>'search'),
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
			'genServices' => array(self::MANY_MANY, 'GenServices', 'gen_serv_life_situations(life_situation_id, service_id)'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'name' => 'Життєва ситуація',
			'visability' => 'Видимість',
			'icon' => 'Піктограма',
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
		$criteria->compare('visability',$this->visability,true);
		$criteria->compare('icon',$this->icon,true);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenLifeSituation the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
