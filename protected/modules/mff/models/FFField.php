<?php

/**
 * This is the model class for table "form_field".
 *
 * The followings are the available columns in table 'form_field':
 * @property integer $id
 * @property integer $formid
 * @property string $name
 * @property integer $type
 * @property string $description
 */
class FFField extends CActiveRecord
{
	/**
	 * @return string the associated database table name
	 */
	public function tableName()
	{
		return 'ff_field';
	}

	/**
	 * @return array validation rules for model attributes.
	 */
	public function rules()
	{
		// NOTE: you should only define rules for those attributes that
		// will receive user inputs.
		return array(
			array('formid, name, type', 'required','message'=>'Отсутсвует обязательный параметр: {attribute}'),
			array('formid, type, order, protected', 'numerical', 'integerOnly'=>true,'allowEmpty'=>false,'message'=>'Поле: {attribute} должно содержать целое число'),
			array('name', 'length', 'min'=>1,'max'=>45,'allowEmpty'=>false, 'message'=>'Поле: {attribute} - не правильной длины. Необходимо 1-45 символов'),
                        array('name', 'match', 'pattern' => '/^[A-Za-z][A-Za-z0-9_]*$/u','message'  => 'Название поля содержит недопустимые символы.'),
			array('default,description', 'safe'),
			// The following rule is used by search().
			// @todo Please remove those attributes that should not be searched.
			array('id, formid, name, type, description, order, protected', 'safe', 'on'=>'search'),
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
                    'typeItem' => array(self::BELONGS_TO, 'FFTypes', 'type'),
                    'registryItem' => array(self::BELONGS_TO, 'FFRegistry', 'formid'),
		);
	}

	/**
	 * @return array customized attribute labels (name=>label)
	 */
	public function attributeLabels()
	{
		return array(
			'id' => 'ID',
			'formid' => 'Formid',
			'name' => 'Имя',
			'type' => 'Тип',
			'default' => 'Умолчание',
			'description' => 'Описание',
			'order' => 'Порядок',
                        'protected' => 'Защищеный',
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
		$criteria->compare('formid',$this->formid);
		$criteria->compare('name',$this->name,true);
		$criteria->compare('type',$this->type);
		$criteria->compare('description',$this->description,true);
		$criteria->compare('order',$this->order);
		$criteria->compare('protected',$this->protected);

		return new CActiveDataProvider($this, array(
			'criteria'=>$criteria,
		));
	}

	/**
	 * Returns the static model of the specified AR class.
	 * Please note that you should have this exact method in all your CActiveRecord descendants!
	 * @param string $className active record class name.
	 * @return FormField the static model class
	 */
	public static function model($className=__CLASS__)
	{
		return parent::model($className);
	}
        
       public function isProtected() {
            if (Yii::app()->getModule('mff')->enableprotected) {
                return ($this->protected==1) || ($this->registryItem->protected==1);
            } else {
                return FALSE;
            }
        }
        
        public function save($runValidation = true, $attributes = null) {
            try{
                $trans=Yii::app()->getDb()->beginTransaction();
                $result= parent::save($runValidation, $attributes);
                $trans->commit();
                return $result;
            } catch (Exception $e) {
                $trans->rollback();
                return false;
            }
        }

        public function delete() {
            try{
                $trans=Yii::app()->getDb()->beginTransaction();
                $result= parent::delete();
                $trans->commit();
                return $result;
            } catch (Exception $e) {
                $trans->rollback();
                return false;
            }
        }

        
        protected function afterSave() {           
            if ($this->isNewRecord) {
                Yii::app()->getDb()->createCommand("call `FF_AI_FIELD`(:id)")->execute(array(":id"=>$this->id));
            } else {
                Yii::app()->getDb()->createCommand("call `FF_AU_FIELD`(:id)")->execute(array(":id"=>$this->id));
            }            
            Yii::app()->getDb()->createCommand("call FF_ALTTBL(:idregistry)")->execute(array(":idregistry"=>$this->formid));                         
        }
        
        protected function afterDelete() {
            parent::afterDelete();
            Yii::app()->getDb()->createCommand("call FF_ALTTBL(:idregistry);")->execute(array(":idregistry"=>$this->formid)); 
        }
        
        protected function beforeDelete() {
            Yii::app()->getDb()->createCommand("call `FF_BD_FIELD`(:id)")->execute(array(":id"=>$this->id));
            return parent::beforeDelete();
        }


}
