<?php

/**
 * This is the model class for table "form_default".
 *
 * The followings are the available columns in table 'form_default':
 * @property string $id
 * @property integer $storage
 * @property integer $registry
 *
 * The followings are the available model relations:
 * @property FormStorage $storage0
 * @property FormRegistry $registry0
 */
class FFModel extends CActiveRecord
{
    private $_ff_tablename = 'ff_default';
    
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
            try {
                if ($this->registry) {
                    $cmd =  Yii::app()->getDb()->createCommand("select concat('ff_',tablename) from `ff_registry` where (id=:idregistry) and (attaching=0)");
                    $cmd->params["idregistry"]=$this->registry;
                    $this->_ff_tablename = $cmd->queryScalar();     
                    if (!$this->_ff_tablename) {
                        $this->_ff_tablename = 'ff_default';
                    }                    
                }
            } catch (Exception $e) {
                 $this->_ff_tablename = 'ff_default';
            }
            return $this->_ff_tablename;
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('storage, registry', 'required'),
			array('storage, registry', 'numerical', 'integerOnly'=>true),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, storage, registry', 'safe', 'on'=>'search'),
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
			'storageItem' => array(self::BELONGS_TO, 'FFStorage', 'storage'),
			'registryItem' => array(self::BELONGS_TO, 'FFRegistry', 'registry'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'storage' => 'Ссылка на хранилище',
			'registry' => 'Ссылка на регистрацию',
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
		$criteria->compare('storage',$this->storage);
		$criteria->compare('registry',$this->registry);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return FormDefault the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
               
}
