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
    const ref_multiguide = 2;          
    const ref_multiguide_storage = 2;          
    
    private $_ff_tablename = 'ff_default';
    private $_registry=1;
    private $_attaching=0;
    public function getAttaching(){
        return $this->_attaching;
    }

    public function __set($name, $value) {
        if ($name=="registry") {
            $this->_registry=$value;
        }
        if ($this->hasAttribute($name)) {
            parent::__set($name, $value);   
        }
    }

    public function __get($name) {       
        if ($name=="registry" && !$this->hasAttribute($name)) {
            $result=$this->_registry;
        } else {
            $result=parent::__get($name);
        }
        return $result;
    }
   
    protected function _gettablename(){
        $cmd =  $this->getDbConnection()->createCommand("select tablename, attaching from `ff_registry` where (id=:idregistry)");
        $cmd->params[":idregistry"]=$this->registry;
        $result=$cmd->queryRow();
        $this->_attaching=$result["attaching"];
        return $result["attaching"]?$result["tablename"]:"ff_".$result["tablename"];
    }

    /**
     * @return string the associated database table name
     */
    public function tableName()
    {
        try {           
            $this->_ff_tablename=$this->_gettablename();     
            if (!$this->_ff_tablename) {
                $this->_ff_tablename = 'ff_default';
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
        $result=array(
                    'storageItem' => array(self::BELONGS_TO, 'FFStorage', 'storage'),
                    'registryItem' => array(self::BELONGS_TO, 'FFRegistry', 'registry'),                   
            );
         return $result;
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
        $model->registry=1;
        $model->refreshMetaData();
        $model->attachBehaviors($model->behaviors());
        return $model;
    }

    public function save($runValidation = true, $attributes = null) {       
        $trans=Yii::app()->getDb()->beginTransaction();
        if ($this->_attaching==0) {
            if ($this->isNewRecord) {
                $cmd=Yii::app()->getDb()->createCommand("call `FF_INITID`(:idregistry,:idstorage, @id)");
                $cmd->execute(array(":idregistry"=> $this->registry,":idstorage"=>  $this->storage));
                $this->id=Yii::app()->getDb()->createCommand('select @id')->queryScalar();
                $this->setIsNewRecord(FALSE);               
                $this->setScenario("update");
            }
            // сброс даты для значений по умолчанию (проблема с датой)
            foreach ($this->attributes as $key => $value) {
                unset($field);
                $field=FFField::model()->find("(`formid`=".$this->registry.") and (`type` in (3,7)) and `name`=:name",array(":name"=>$key));
                if ($value=="" || (isset($field) && ($value==$field->default) || ($value=="CURRENT_TIMESTAMP"))) $this->setAttribute($key, NULL);
            }      
        }
        // сохранение
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
         if ($this->_attaching==0) Yii::app()->getDb()->createCommand("call `FF_SYNCDATA`(:ID)")->execute(array(":ID"=>  $this->id));
    }

    protected function beforeDelete() {
        parent::afterDelete();
         if ($this->_attaching==0) {
             Yii::app()->getDb()->createCommand("call `FF_HELPER_SYNCDATA_DELETE`(:ID)")->execute(array(":ID"=>  $this->id));
         }
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
	
    public function refresh() {
        $this->refreshMetaData();
        $result=parent::refresh();
    }

    public function refreshMetaData() {
        $registrysave=$this->registry;
        $this->tableName();
        parent::refreshMetaData();
        $this->registry=$registrysave;
    }

    public function getItems($name) {
        $field=FFField::model()->find("`formid`=:formid and `name`=:name",
                array(":formid"=>$this->registry, ":name"=>$name ));
        $multilink=new FFModel;
        $multilink->registry=self::ref_multiguide;
        $multilink->refreshMetaData();
        $criteria=new CDbCriteria();
        $criteria->select="`reference`";
        $criteria->addCondition("`registry`=".self::ref_multiguide);
        $criteria->addCondition("`owner`=".$this->id);
        $criteria->addCondition("`owner_field`=:owner_field");
        $criteria->params[":owner_field"]=$field->id;
        $criteria->order="`order`";
        $list=$multilink->findAll($criteria);
        $result=array();
        foreach ($list as $listitem) {
            $item=FFModel::model()->findByPk($listitem->reference);
            $item->refresh();
            $result=array_merge($result,array($item));           
        }
        return $result;
    }
}

/// Временый класс для справочников
class fieldlist_FFModel extends FFModel {} 
/// Временый класс для справочников
class subguide_FFModel extends FFModel {} 


