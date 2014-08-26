<?php

/**
 * This is the model class for table "gen_serv_cat_con".
 *
 * The followings are the available columns in table 'gen_serv_cat_con':
 * @property string $id
 * @property integer $categorie_id
 * @property integer $service_id
 *
 * The followings are the available model relations:
 * @property GenServCategories $categorie
 * @property GenServices $service
 */
class GenServCatCon extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_serv_cat_con';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('categorie_id, service_id', 'required'),
			array('categorie_id, service_id', 'numerical', 'integerOnly'=>true),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, categorie_id, service_id', 'safe', 'on'=>'search'),
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
			'categorie' => array(self::BELONGS_TO, 'GenServCategories', 'categorie_id'),
			'service' => array(self::BELONGS_TO, 'GenServices', 'service_id'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'categorie_id' => 'ID категорії',
			'service_id' => 'ID послуги',
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
		$criteria->compare('categorie_id',$this->categorie_id);
		$criteria->compare('service_id',$this->service_id);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenServCatCon the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
