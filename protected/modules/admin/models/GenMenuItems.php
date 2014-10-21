<?php

/**
 * This is the model class for table "gen_menu_items".
 *
 * The followings are the available columns in table 'gen_menu_items':
 * @property integer $id
 * @property string $content
 * @property integer $paderntid
 * @property string $url
 * @property integer $ref
 * @property integer $visability
 *
 * The followings are the available model relations:
 * @property GenOtherInfo[] $genOtherInfos
 */
class GenMenuItems extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'gen_menu_items';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('content, url, ref, visability', 'required'),
			array('paderntid, ref, visability', 'numerical', 'integerOnly'=>true),
			array('content, url', 'length', 'max'=>45),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, content, paderntid, url, ref, visability', 'safe', 'on'=>'search'),
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
			'genOtherInfos' => array(self::HAS_MANY, 'GenOtherInfo', 'kind_of_publication'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => '№ з/п',
			'content' => 'Назва пункту',
			'paderntid' => 'Породжений',
			'url' => 'URL',
			'ref' => 'Послідовність',
			'visability' => 'Видимість (0/1)',
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
		$criteria->compare('content',$this->content,true);
		$criteria->compare('paderntid',$this->paderntid);
		$criteria->compare('url',$this->url,true);
		$criteria->compare('ref',$this->ref);
		$criteria->compare('visability',$this->visability);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
		
/*
		$users=GenMenuItems::model()->with(array(
        'genOtherInfos'=>array(
        'select'=>array('kindOfPublication.id'),
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
	 * @return GenMenuItems the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
}
