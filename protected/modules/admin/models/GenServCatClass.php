<?php

/**
 * This is the model class for table "gen_serv_cat_class".
 *
 * The followings are the available columns in table 'gen_serv_cat_class':
 * @property integer $id
 * @property integer $service_id
 * @property integer $cat_class_id
 *
 * The followings are the available model relations:
 * @property GenCatClasses $catClass
 * @property GenServices $service
 */
class GenServCatClass extends CActiveRecord
{
	public $srv_name;
	public $class_name;
	public $cat_name;
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_serv_cat_class';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('service_id, cat_class_id', 'required'),
			array('service_id, cat_class_id', 'numerical', 'integerOnly'=>true),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, service_id, cat_class_id', 'safe', 'on'=>'search'),
			array('srv_name, class_name, cat_name', 'safe', 'on'=>'search'),
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
			'catClass' => array(self::BELONGS_TO, 'GenCatClasses', 'cat_class_id'),
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
			'cat_class_id' => 'ID комбінації Категорія-Клас',
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
        $criteria->with = array( 'catClass', 'service','catClass.categorie','catClass.class' );
		$criteria->compare('t.id',$this->id);
		$criteria->compare('service_id',$this->service_id);
		$criteria->compare('cat_class_id',$this->cat_class_id);
        // $criteria->compare( 'service.name', $this->srv_name, true );
		//$criteria->compare( 'catClass.class.item_name', $this->class_name, true );
		//$criteria->compare( 'catClass.categorie.name', $this->cat_name, true);
		$criteria->addSearchCondition('service.name', $this->srv_name);
		$criteria->addSearchCondition('class.item_name', $this->class_name);
		$criteria->addSearchCondition('categorie.name', $this->cat_name);
		
		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
			
		'sort'=>array(
           'attributes'=>array(
           'id'=>array(
                'asc'=>'t.id',
                'desc'=>'t.id DESC',
            ),
		   'srv_name'=>array(
                'asc'=>'service.name',
                'desc'=>'service.name DESC',
            ),
			'class_name'=>array(
                'asc'=>'class.item_name',
                'desc'=>'class.item_name DESC',
            ),
			'cat_name'=>array(
                'asc'=>'categorie.name',
                'desc'=>'categorie.name DESC',
            ),
           ),
          ),
			
		));
	}
	
	
	
	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return GenServCatClass the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
