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
    const available_nodes = 16;
    const available_nodes_for_user = 17;
    const available_nodes_for_role = 18;
    const available_nodes_storage = 11;
    const available_actions = 21;
    const available_actions_for_user = 23;
    const available_actions_for_role = 22;
    const available_actions_storage = 14;
    const route_action = 5;
    const route_action_storage = 3;
    const route_node = 6;
    const route_node_storage = 4;
    const route = 7;
    const route_storage = 5;
    const route_folder = 8;
    const route_folder_storage = 6;
    const route_cabinet = 9;
    const route_cabinet_storage = 7;
    
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
        try {
            $cmd =  $this->getDbConnection()->createCommand("select tablename, attaching from `ff_registry` where (id=:idregistry)");
            $cmd->params[":idregistry"]=$this->registry;
            $result=$cmd->queryRow();
            $this->_attaching=$result["attaching"];
            if (!isset($result)) return null;
            if (!isset($result["tablename"])) return null;
            return ($result["attaching"]==1)?$result["tablename"]:"ff_".$result["tablename"];
        } catch (Exception $e) {
            return null;
        }
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
            $adp = new CActiveDataProvider($this);
            $adp->model->registry=$this->registry;
            $adp->model->refreshMetaData();
            $adp->setCriteria($criteria);
            return $adp;
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
        $storage=FFStorage::model()->find("`type`=:type",array(":type"=>$field->type));
        if ($storage==NULL) return NULL;
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
            foreach ($storage->registryItems as $registryItem) {
                $findmodel = new subguide_FFModel();
                $findmodel->registry=$registryItem->id;
                $findmodel->refreshMetaData();
                $item=$findmodel->findByPk($listitem->reference);
                if ($item!=NULL) {
                    $item->registry=$registryItem->id;
                    $item->refresh();                   
                    if ($item->_gettablename()!=NULL) {
                        $result=array_merge($result,array($item));  
                        break;
                    }                    
                 }
            }
        }
        return $result;
    }
    
//    public function getBackItems($name="") {
//        $field=FFField::model()->find("`formid`=:formid and `name`=:name",
//                array(":formid"=>$this->registry, ":name"=>$name ));
//        $multilink=new FFModel;
//        $multilink->registry=self::ref_multiguide;
//        $multilink->refreshMetaData();
//        $criteria=new CDbCriteria();
//        $criteria->select="`owner`";
//        $criteria->addCondition("`registry`=".self::ref_multiguide);
//        $criteria->addCondition("`reference`=".$this->id);
//        if ($name!=""){
//            $criteria->addCondition("`owner_field`=:owner_field");
//            $criteria->params[":owner_field"]=$field->id;
//        }
//        $list=$multilink->findAll($criteria);
//        $result=array();
//        foreach ($list as $listitem) {
//            $item=subguide_FFModel::model()->findByPk($listitem->owner);
//            if ($item!=NULL) {
//                $item->refresh();
//                $result=array_merge($result,array($item));    
//            }
//        }
//        return $result;
//    }    
    
    public function setMultiGuide($name,$value) {
//        if ($this->getScenario()=="insert") return;
        if (is_int($name)) {
            $field=FFField::model()->findByPk($name);            
        } else {
            $field=FFField::model()->find("`formid`=:formid and `name`=:name",
                    array(":formid"=>$this->registry, ":name"=>$name ));            
        }
        Yii::app()->db->createCommand("DELETE FROM `ff_ref_multiguide` WHERE `owner_field`=:owner_field and `owner`=".$this->id)->execute(array(":owner_field"=>$field->id));
        foreach ($value as $index => $itemid) {
            $classnamefiled="FFModel_".$name;
            eval("class $classnamefiled extends FFModel {}");
            $vf2FFModel=new $classnamefiled;
            $vf2FFModel->registry=FFModel::ref_multiguide;
            $vf2FFModel->storage=FFModel::ref_multiguide_storage;                            
            $vf2FFModel->refreshMetaData();
            $vf2FFModel->setAttribute("order",$index);
            $vf2FFModel->setAttribute("owner",$this->id);
            $vf2FFModel->setAttribute("owner_field",$field->id);
            $vf2FFModel->setAttribute("reference",$itemid);
            $vf2FFModel->save();
       }
    }

     public function getField($name) {
        $field=FFField::model()->find("`formid`=:formid and `name`=:name",
                array(":formid"=>$this->registry, ":name"=>$name ));
        return $field;
    }  
    
    public function getType($name) {
        $field=  $this->getField($name);
        $type=  FFTypes::model()->findByPk($field->type);
        return $type;
    }
    
    // Применяет маршрут к документу
    public function applyRoute() {
        if ($this->hasAttribute("route") && $this->hasAttribute("available_nodes") && $this->getAttribute("route")!=null) {
            // Читаем выбраный маршрут        
            $routeclass=new route_FFModel();
            $routeclass->registry=FFModel::route;
            $routeclass->refreshMetaData();                  
            $routeclass=$routeclass->findByPk($this->route);
            // Читаем из маршрута стартовые узлы
            $start_nodes=$routeclass->getItems("start_route");
            // создаем запись в available_nodes
            $available_nodeIds=array();
            $available_actionIds=array();
            foreach ($start_nodes as $start_node) {
                // Допустимые узлы
                $available_nodesclass=new available_nodes_route_FFModel();
                $available_nodesclass->registry=FFModel::available_nodes;
                $available_nodesclass->refreshMetaData();  
                $available_nodesclass->storage=FFModel::available_nodes_storage;
                $available_nodesclass->node = $start_node->id;               
                // Определить пользователя или роль
                // *********
                // Сохраняем
                $available_nodesclass->save();
                // Допустимые действия
                $nodeclass = new nodes_route_FFModel();
                $nodeclass->registry = FFModel::route_node;
                $nodeclass->refreshMetaData();
                $nodeclass = $nodeclass->findByPk($start_node->id);
                $allow_action = $nodeclass->getItems("allow_action");
                foreach ($available_actions as $available_action) {
                    $available_actionsclass=new available_actions_route_FFModel();
                    $available_actionsclass->registry=FFModel::available_actions;
                    $available_actionsclass->refreshMetaData();  
                    $available_actionsclass->storage=FFModel::available_actions_storage;
                    $available_actionsclass->node = $start_node->id;   
                    $available_actionsclass->action = $available_action->id;   
                    // Определить пользователя или роль
                    // *********
                    // Сохраняем
                    $available_actionsclass->save();
                    // Список ИД действий
                    $available_actionIds=array_megre($available_actionIds,array($available_actionsclass->id));
                }
                $available_nodeIds=array_merge($available_nodeIds,array($available_nodesclass->id));
            }
            // Устанавливаем в текущем документе привязку к узлам
            $this->setMultiGuide("available_nodes",$available_nodeIds);
            // Устанавливаем разрешенные действия на документе
            $this->setMultiGuide("available_actions",$available_actionIds);
        }         
    }
        
    /// Допустимые действия для документа в узле
    public function getActionsFromNode($nodeid, $user=null) {
        $result=array();
        $available_actions=$this->getItems("available_actions");
        foreach ($available_actions as $available_action) {
            if ($available_action->node==$nodeid) {
                $actionclass=new actions_route_FFModel();
                $actionclass->registry=  FFModel::route_action;
                $actionclass->refreshMetaData();
                $actionclass=$actionclass->findByPk($available_action->action);
                $result=array_merge($result,array($actionclass));
            }
        }
        $result=array_unique($result);
        return $result;
    }
    
    /// Допустимые действия для документа в папке
    public function getActionsFromFolder($folderid, $user=null) {
        $result=array();
        $folder =new folder_route_FFModel();
        $folder->registry=  FFModel::route_folder;
        $folder->refreshMetaData();
        $folder=$folder->findByPk($folderid);
        $nodes=$folder->getItems("nodes");
        
        $available_actions=$this->getItems("available_actions");
        foreach ($available_actions as $available_action) {
            foreach ($nodes as $node) {
                if ($available_action->node==$node->id) {
                    $actionclass=new actions_route_FFModel();
                    $actionclass->registry=  FFModel::route_action;
                    $actionclass->refreshMetaData();
                    $actionclass=$actionclass->findByPk($available_action->action);
                    $result=array_merge($result,array($actionclass));
                }                
            }
        }
        $result=array_unique($result);
        return $result;
    }
    
    // Применяет действие к документу
    public function applyAction($actionId) {   
        // Разрешенные узлы
        $available_nodes=$this->getItems("available_nodes");
        // Загружаем действие
        $action=new actions_route_FFModel();
        $action->registry=  FFModel::route_action;
        $action->refreshMetaData();
        $action=$actionclass->findByPk($actionId);
        $clearnodes=$action->getItems("clearnodes");
        // Очищаем узлы согластно действию
        foreach ($available_nodes as $available_node) {
            foreach ($clearnodes as $node) {
                if ($available_node->node == $node->id) {
                    $available_node->delete();
                }
            }           
        }
        // Считываем узлы которые необходимо добавить
        $gotonodes=$action->getItems("gotonodes");
        // Убираем те узлы которые уже присутствуют
        foreach ($available_nodes as $available_node) {
            $index=0;
            foreach ($gotonodes as $node) {
                if ($node->id==$available_node->node) {
                    unset($gotonodes);
                } else $index++;
            }            
        }
        // Добавляем в допустимые узлы - новые узлы
        foreach ($gotonodes as $node) {
                $available_nodesclass=new available_nodes_route_FFModel();
                $available_nodesclass->registry=FFModel::available_nodes;
                $available_nodesclass->refreshMetaData();  
                $available_nodesclass->storage=FFModel::available_nodes_storage;
                $available_nodesclass->node = $node->id;               
                // Определить пользователя или роль
                // *********
                // Сохраняем
                $available_nodesclass->save();
                // Допустимые действия                
//                $allow_action = $node->getItems("allow_action");
//                foreach ($available_actions as $available_action) {
//                    $available_actionsclass=new available_actions_route_FFModel();
//                    $available_actionsclass->registry=FFModel::available_actions;
//                    $available_actionsclass->refreshMetaData();  
//                    $available_actionsclass->storage=FFModel::available_actions_storage;
//                    $available_actionsclass->node = $node->id;   
//                    $available_actionsclass->action = $available_action->id;   
//                    // Определить пользователя или роль
//                    // *********
//                    // Сохраняем
//                    $available_actionsclass->save();
                    // Список ИД действий
                    $available_actionIds=array_megre($available_actionIds,array($available_actionsclass->id));
//                }
                $available_nodeIds=array_merge($available_nodeIds,array($available_nodesclass->id));
            }
            // Устанавливаем в текущем документе привязку к узлам
            $this->setMultiGuide("available_nodes",$available_nodeIds);
            // Устанавливаем разрешенные действия на документе
            $this->setMultiGuide("available_actions",$available_actionIds);

    }
}


/// Временый класс для справочников
class fieldlist_FFModel extends FFModel {} 
/// Временый класс для справочников
class subguide_FFModel extends FFModel {} 

class route_FFModel extends FFModel {} 
class available_nodes_route_FFModel extends FFModel {} 
class nodes_route_FFModel extends FFModel {} 
class available_actions_route_FFModel extends FFModel {} 
class actions_route_FFModel extends FFModel {} 
class folder_route_FFModel extends FFModel {} 


