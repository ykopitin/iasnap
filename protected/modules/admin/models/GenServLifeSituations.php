<?php

/**
 * This is the model class for table "gen_serv_life_situations".
 *
 * The followings are the available columns in table 'gen_serv_life_situations':
 * @property integer $id
 * @property integer $service_id
 * @property integer $life_situation_id
 *
 * The followings are the available model relations:
 * @property GenLifeSituation $lifeSituation
 * @property GenServices $service
 */
class GenServLifeSituations extends CActiveRecord
{

     public $service_n;
	 public $situation;
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_serv_life_situations';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('service_id, life_situation_id', 'required'),
			array('id, service_id, life_situation_id', 'numerical', 'integerOnly'=>true),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, service_id, life_situation_id', 'safe', 'on'=>'search'),
			array('service_id', 'ext.UniqueAttributesValidator.UniqueAttributesValidator', 'with'=>'life_situation_id','message'=>'Така комбінація послуга - життєва ситуація вже існує у базі даних!'),
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
			'lifeSituation' => array(self::BELONGS_TO, 'GenLifeSituation', 'life_situation_id'),
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
			'service_id' => 'Послуга',
			'life_situation_id' => 'Життєва ситуація',
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
$criteria->with = array('service', 'lifeSituation');
		$criteria->compare('id',$this->id);
		$criteria->compare('service_id',$this->service_id);
		$criteria->compare('life_situation_id',$this->life_situation_id);
        $criteria->addSearchCondition('service.name', $this->service_n);
		$criteria->addSearchCondition('lifeSituation.name', $this->situation);
		
		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
				'sort'=>array(
        'attributes'=>array(
           'id'=>array(
                'asc'=>'t.id',
                'desc'=>'t.id DESC',
            ),
		   'service_n'=>array(
                'asc'=>'service.name',
                'desc'=>'service.name DESC',
            ),
			'situation'=>array(
                'asc'=>'lifeSituation.name',
                'desc'=>'lifeSituation.name DESC',
            ),
           ),
          ),
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenServLifeSituations the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
