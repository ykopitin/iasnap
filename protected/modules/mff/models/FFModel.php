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
//    private $_registry = 1;
      
    protected function _gettablename(){
        $cmd =  $this->getDbConnection()->createCommand("select concat('ff_',tablename) from `ff_registry` where (id=:idregistry) and (attaching=0)");
        $cmd->params[":idregistry"]=$this->registry;
        return $cmd->queryScalar();
    }

    /**
     * @return string the associated database table name
     */
    public function tableName()
    {
        try {
            if (isset($this->registry) && $this->registry) {
                $this->_ff_tablename=$this->_gettablename();     
                if (!$this->_ff_tablename) {
                    $this->_ff_tablename = 'ff_default';
                }                    
            } else {
                $this->_ff_tablename = 'ff_default';
            }
        } catch (Exception $e) {
             $this->_ff_tablename = 'ff_default';
        }
        return $this->_ff_tablename;
    }

//    public function __set($name, $value) {
//        if (strtolower($name)=="registry") {
//            $this->_registry=$value;   
//        }
//        parent::__set($name, $value);
//    }

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
        $model=new FFModel();
        $model->refreshMetaData();
        $model->refresh();
        $model->attachBehaviors($model->behaviors());
        return $model;
    }

    public function save($runValidation = true, $attributes = null) {
        $trans=Yii::app()->getDb()->beginTransaction();
        foreach ($this->attributes as $key => $value) {
            // ОбNULLяем пустую строку (проблема с датой)
            if ($value=="") $this->setAttribute($key, NULL);
        }
        if ($this->isNewRecord) {
            $cmd=Yii::app()->getDb()->createCommand("call `FF_INITID`(:idregistry,:idstorage, @id)");
            $cmd->execute(array(":idregistry"=> $this->registry,":idstorage"=>  $this->storage));
            $this->id=Yii::app()->getDb()->createCommand('select @id')->queryScalar();
            $this->setIsNewRecord(FALSE);               
            $this->setScenario("update");
        }
        $result=parent::save($runValidation, $attributes);
        if ($result) {
            $trans->commit();
        } else {
            $trans->rollback();
        }
        return $result;
    }

    protected function afterSave() {
        parent::afterSave();
        Yii::app()->getDb()->createCommand("call `FF_SYNCDATA`(:ID)")->execute(array(":ID"=>  $this->id));
    }

    protected function beforeDelete() {
        parent::afterDelete();
        Yii::app()->getDb()->createCommand("call `FF_HELPER_SYNCDATA_DELETE`(:ID)")->execute(array(":ID"=>  $this->id));
    }



    public static function isParent($registry1,$registry2) {
        return Yii::app()->getDb()->
                createCommand("select `FF_isParent`(:idregistry1,:idregistry2)")->
                queryScalar(array(":idregistry1"=>$registry1,":idregistry2"=>$registry2));
    }

    // Bcghfdbnm 
    public static function commonParent($registrys) {
        if (is_array($registrys) && count($registrys)>0) {
            $commonP=$registrys[0];
            for ($i=1;$i<count($registrys);$i++){
                $commonP = self::isParent($commonP,$registrys[$i]);            
            }
            return $commonP;
        }
        return $registrys;
    }

//   public static $_md=array();
//   public function getMetaData() {
//        if (!array_key_exists($this->_registry,self::$_md)) {
//            self::$_md[$this->_registry]=null;
//            self::$_md[$this->_registry]=new CActiveRecordMetaData($this);  
//        }           
//        return self::$_md[$this->_registry];
////        echo '<pre>';
////        var_dump(new CActiveRecordMetaData($this));
////        echo '</pre>';
////        Yii::app()->end();
////        return new CActiveRecordMetaData($this);
//    }
//
//    public function refreshMetaData() {
//        if (array_key_exists($this->_registry,self::$_md)) {
//            unset(self::$_md[$this->_registry]);
//        }
//    }

//    private static $_md=array();
//	public function getMetaData()
//	{         
//		$className= isset($this->registry)?$this->registry:1;
//		if(!array_key_exists($className,self::$_md))
//		{
//			self::$_md[$className]=null; // preventing recursive invokes of {@link getMetaData()} via {@link __get()}
//			self::$_md[$className]=new CActiveRecordMetaData($this);
//		}
//		return self::$_md[$className];
//	}
//	public function refreshMetaData()
//	{
//		$className=isset($this->registry)?$this->registry:1;
//		if(array_key_exists($className,self::$_md))
//			unset(self::$_md[$className]);
//	}    

}

/// Временый класс для справочников
class fieldlist_FFModel extends FFModel {} 
/// Временый класс для справочников
class subguide_FFModel extends FFModel {} 


