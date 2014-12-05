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
    const available_nodes_for_cnap = 41;
    const available_nodes_storage = 11;
    const available_actions = 21;
    const available_actions_for_user = 23;
    const available_actions_for_role = 22;
    const available_actions_for_cnap = 42;
    const available_actions_storage = 14;
    const route_action = 5;
    const route_action_for_role = 25;
    const route_action_for_user = 26;
    const route_action_for_cnap = 40;
    const route_action_storage = 3;
    const route_node = 6;
    const route_node_storage = 4;
    const route = 7;
    const route_for_user = 28;
    const route_for_role = 27;
    const route_storage = 5;
    const route_folder = 8;
    const route_folder_storage = 6;
    const route_cabinet = 9;
    const route_cabinet_for_role = 12;
    const route_cabinet_for_users = 15;
    const route_cabinet_storage = 7;
    const document_base=13;
    const document_cnap=36;
    const role=11;
    const user=10;
    
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
            @$result=$cmd->queryRow();
            if (!isset($result) || $result==null) return null;
            if (!isset($result["tablename"])) return null;
            $this->_attaching=$result["attaching"];
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
//'storageItems' => array(self::MANY_MANY, 'FFStorage', 'ff_registry_storage(registry, storage)'),
//                    'fields' => array(self::MANY_MANY, 'FFField', 'ff_field(formid,registry)'),                   
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
                    'storage' => 'Посилання на сховище',
                    'registry' => 'Посилання на реєстрацію',
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

    /// Проверяет наличие поля
    public function hasField($name) {
        try{
            $field=  FFField::model()->find("`formid`=:fromid and `name`=:name",array(":formid"=>$this->registry,":name"=>$name));
            if (isset($field) && $field!=NULL) return FALSE;
            else return TRUE;
        } catch (Exception $e) {
            return FALSE;
        }
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

    public function delete() {       
        if ($this->_attaching==0) {    
            if($this->beforeDelete())
                {
                        Yii::app()->getDb()->createCommand(
                                "call `FF_HELPER_SYNCDATA_DELETE`(:ID)")->execute(array(":ID"=>  $this->id));
                        $this->afterDelete();
                        return true;
                }
                else
                        return false;            
        } else parent::delete();
    }

    public static function isParent($registry1,$registry2) {       
        return Yii::app()->getDb()->
                createCommand("select `FF_isParent`(:idregistry1,:idregistry2)")->
                queryScalar(array(":idregistry1"=>$registry1,":idregistry2"=>$registry2));
    }

     
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
        $field=$this->getField($name);
        if (!isset($field) || $field==null) return null;
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
        $criteria->params[":owner_field"]=$field->name;
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
    
    public function setMultiGuide($name,$value) { 
        if ($name==null) return false;
        $field=$this->getField($name);     
        if (empty($field) || $field==NULL) return false;           
        Yii::app()->db->createCommand(
            "DELETE FROM `ff_ref_multiguide` WHERE `owner_field`=:owner_field and `owner`=".$this->id)->
            execute(array(":owner_field"=>$field->name));
        foreach ($value as $index => $itemid) {
            $vf2FFModel=new ref_multiguide_FFModel();
            $vf2FFModel->registry=FFModel::ref_multiguide;
            $vf2FFModel->storage=FFModel::ref_multiguide_storage;                            
            $vf2FFModel->refreshMetaData();
            $vf2FFModel->setAttribute("order",$index);
            $vf2FFModel->setAttribute("owner",$this->id);
            $vf2FFModel->setAttribute("owner_field",$field->name);
            $vf2FFModel->setAttribute("reference",$itemid);
            $vf2FFModel->save();
       }
       return true;
    }

     public function getField($name) {        
        if (is_numeric($name)) {
            $field=FFField::model()->findByPk($name);            
        } else {
            $field=FFField::model()->find("`formid`=:formid and `name`=:name",
                    array(":formid"=>$this->registry, ":name"=>$name ));            
        }        
        return $field;
    }  
    
    public function getFieldValue($name) {
        $field=$this->getField($name);
        if (empty($field) || $field==NULL) return NULL;
        switch ($field->getAttribute("type")) {
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '16':
            case '17':
            case '18':
            case '19':
                return $this->getAttribute($name);
                break;
            case '8':
                Yii::import("mff.components.utils.tracknumberUtil");
                $tracknumber=tracknumberUtil::getTracknumberFromId($this->id);
                return $tracknumber;
                break;
            case '9':
                return CHtml::link("Малюнок",  
                        Yii::app()->createUrl(
                                "/mff/formview/getimage",
                                array(
                                    "id"=>  $this->id, 
                                    "name"=>$field->name
                                    )
                                )
                        );
                break;
            case '10':
                $filelink="Відсутній";
                    if ($this->getAttribute($field->name."_filename")!="") {
                    $filelink=CHtml::link(
                        "Переглянути",
                        Yii::app()->createUrl(
                                "/mff/formview/getfile",
                                array(
                                    "id"=>  $this->id, 
                                    "name"=>$this->getAttribute($field->name."_filename")
                                    )
                                )
                        );
                    }
                return $filelink;    
                break;
            case '14':
                $filelink="Відсутній";
                if ($this->getAttribute($field->name."_fileedsname")!="") {
                    $linkclick="CabinetLoadFile('".Yii::app()->request->getHostInfo().Yii::app()->createUrl(
                                "/mff/formview/getfile",
                                array(
                                    "id"=>  $this->id, 
                                    "name"=>$field->name
                                    )
                                )."')";
                    $filelink=CHtml::link(
                        "Переглянути",
                        "#",
                        array("onclick"=>$linkclick)
                        );
                }
                return $filelink;
                break;               
            default :                  
                switch ($field->typeItem->getAttribute("view")){
                    case "combobox":
                    case "listbox":
                    case "innerguide":
                    case "radiobox":
                        $valueField=$this->getAttribute($field->name);
                        if (empty($valueField) || $valueField==NULL) return NULL;
                        $storage=FFStorage::model()->find("type=:type",array(":type"=>$field->getAttribute("type")));
                        if (empty($storage) || $storage==NULL) return NULL;
                        if (isset($storage->fields) && $storage->fields!="") {
                            $_fieldNames=explode(";", $storage->fields);
                            $fieldNames=array();
                            foreach ($_fieldNames as $_fieldName) {
                                $fieldName=  explode(":",trim($_fieldName));
                                if (count($fieldName)==2) {
                                    $fieldNames=array_merge($fieldNames,  array(trim($fieldName[0])=>trim($fieldName[1])));
                                } elseif (count($fieldName)==1) {
                                    $fieldNames=array_merge($fieldNames,  array(trim($fieldName[0])=>trim($fieldName[0])));                                
                                }
                            }
                        } 
                        if (empty($storage) || $storage==NULL) return NULL;
                        foreach ($storage->registryItems as $registryItem) {
                            $subitem=new subguide_FFModel();
                            $subitem->registry=$registryItem->id;
                            $subitem->refreshMetaData();
                            $subitem=$subitem->findByPk($valueField);
                            if (empty($subitem) || $subitem==NULL) {
                                continue;
                            } 
                            if (isset($storage->fields) && $storage->fields!="") {
                                $_valueField="";
                                foreach ($fieldNames as $fieldName => $fieldCaption) {
                                    $_value=$subitem->getAttribute($fieldName);
                                    if ($fieldName==$fieldCaption) {
                                        $_valueField.=$_value."; ";
                                    } else {
                                        $_valueField.=$fieldCaption.": ".$_value."; ";
                                    }
                                }
                                if ($_valueField!="") return $_valueField;
                                return $valueField;
                            } else {
                                if ((int)$subitem->getAttaching()==0) {
                                    return $subitem->getAttribute("name");
                                } else {
                                    return $subitem->id;
                                }
                            }
                        }
                        return NULL;
                        break;
                    case "listbox_multi":
                        $subitems=$this->getItems($field->name);
                        if (empty($subitems) || $subitems==NULL) return NULL;
                        $storage=FFStorage::model()->find("type=:type",array(":type"=>$field->getAttribute("type")));
                        if (empty($storage) || $storage==NULL) return NULL;
                        if (isset($storage->fields) && $storage->fields!="") {
                            $_fieldNames=explode(";", $storage->fields);
                            $result="";
                            foreach ($subitems as $subitem) {
                                if ($result!="") $result.="<br />";
                                foreach ($_fieldNames as $_fieldName) {
                                    $fieldName=  explode(":", $_fieldName);
                                    if (count($fieldName)==2) {
                                        $result.=trim($fieldName[1]).": ".$subitem->getAttribute(trim($fieldName[0]))."; ";
                                    } elseif (count($fieldName)==1) {
                                        $result.=$subitem->getAttribute(trim($fieldName[0]))."; ";                                
                                    }
                                }                                
                            }
                            return $result;
                        } 
                        else {
                            $result="";
                            foreach ($subitems as $subitem) {
                                if ((int)$subitem->getAttaching()==0) {
                                    return $subitem->getAttribute("name");
                                } else {
                                    return $subitem->id;
                                }
                            }
                        }
                        return NULL;
                        break;
                    default :
                        return NULL;
                }                
        }
    }


    public function getType($name) {
        $field=  $this->getField($name);
        $type=  FFTypes::model()->findByPk($field->type);
        return $type;
    }
    
    // Применяет маршрут к документу
    public function applyRoute($userId=null, $apply_first_action=FALSE) {
        if ($this->hasAttribute("route") && $this->hasAttribute("available_nodes") && $this->getAttribute("route")!=null) {
            // Читаем выбраный маршрут        
            $routeclass=new route_FFModel();
            $routeclass->registry=FFModel::route;
            $routeclass->refreshMetaData();                  
            $routeclass=$routeclass->findByPk($this->route);            
            if (empty($routeclass) || $routeclass==NULL) return FALSE;
            $routeclass->refresh();
            // Читаем из маршрута стартовые узлы
            $start_nodes=$routeclass->getItems("start_route");
            $roles=array();
            $users=array();
            $registry_available_nodes=FFModel::available_nodes;
            $registry_available_actions=FFModel::available_actions;
            if ($routeclass->hasField("roles")){
                $_roles=$routeclass->getItems("roles");
                if (isset($_roles) && $_roles!=NULL) {
                    foreach ($_roles as $_role) {
                        $roles=array_merge($roles,array($_role->id));
                    }
                }
                $registry_available_nodes=FFModel::available_nodes_for_role;
                $registry_available_actions=FFModel::available_actions_for_role;
            }
            if ($routeclass->hasField("users")){
                $_users=$routeclass->getItems("users");
                if (isset($_users) && $_users!=NULL) {
                    foreach ($_users as $_user) {
                        $users=array_merge($users,array($_user->id));
                    }
                }
                $registry_available_nodes=FFModel::available_nodes_for_user;
                $registry_available_actions=FFModel::available_actions_for_user;
            }
            // создаем запись в available_nodes
            $available_nodeIds=array();
            $available_actionIds=array();
            foreach ($start_nodes as $start_node) {
                // Допустимые узлы
                $available_nodesclass=new available_nodes_route_FFModel();
                $available_nodesclass->registry=$registry_available_nodes;
                $available_nodesclass->refreshMetaData();  
                $available_nodesclass->storage=FFModel::available_nodes_storage;
                $available_nodesclass->node = $start_node->id;               
                // Сохраняем
                $available_nodesclass->save();
                // Определить пользователя или роль
                switch ($registry_available_nodes) {
                    case FFModel::available_nodes_for_role:
                        $available_nodesclass->setMultiGuide("role", $roles);    
                        break;
                    case FFModel::available_nodes_for_user:
                        $available_nodesclass->setMultiGuide("users", $users);    
                        break;
                }
                // Допустимые действия
                $nodeclass = new nodes_route_FFModel();
                $nodeclass->registry = FFModel::route_node;
                $nodeclass->refreshMetaData();
                $nodeclass = $nodeclass->findByPk($start_node->id);
                $allow_actions = $nodeclass->getItems("allow_action");
                $first_action=null;
                foreach ($allow_actions as $allow_action) {
                    if ($first_action==null) $first_action=$allow_action->id;  
                    $available_actionsclass=new available_actions_route_FFModel();
                    $available_actionsclass->registry=$registry_available_actions;
                    $available_actionsclass->refreshMetaData();  
                    $available_actionsclass->storage=FFModel::available_actions_storage;
                    $available_actionsclass->node = $start_node->id;   
                    $available_actionsclass->action = $allow_action->id;   
                    // Сохраняем
                    $available_actionsclass->save();
                    // Определить пользователя или роль
                    switch ($registry_available_nodes) {
                       case FFModel::available_nodes_for_role:
                           $available_actionsclass->setMultiGuide("role", $roles);    
                           break;
                       case FFModel::available_nodes_for_user:
                           $available_actionsclass->setMultiGuide("users", $users);    
                           break;
                    }
                    // Список ИД действий
                    $available_actionIds=  array_merge($available_actionIds,array($available_actionsclass->id));
                }
                $available_nodeIds=array_merge($available_nodeIds,array($available_nodesclass->id));
            }
            // Устанавливаем в текущем документе привязку к узлам
            $this->setMultiGuide("available_nodes",$available_nodeIds);
            // Устанавливаем разрешенные действия на документе
            $this->setMultiGuide("available_actions",$available_actionIds);
            
            if ($apply_first_action && isset($first_action) && $first_action!=null) {
                $this->applyAction ($first_action, $userId);
            }
            return TRUE;
        }      
        return FALSE;
    }
        
    /// Допустимые действия для документа в узле
    public function getActionsFromNode($nodeid, $user=null) {
        $result=array();
        // Ищем роль для указанного пользователя
        $roleId=NULL;
        if ($user!=null) {
            $_user=new FFModel();
            $_user->registry=FFModel::user;
            $_user->refreshMetaData();
            $_user=$_user->findByPk($user);
            if (isset($_user) && ($_user!=NULL)) $roleId=$_user->user_roles_id;
            else return null;
        }
        $available_actions=$this->getItems("available_actions");
        foreach ($available_actions as $available_action) {
            if ($available_action->node==$nodeid) {
                $actionclass=new actions_route_FFModel();
                $actionclass->registry=  FFModel::route_action;
                $actionclass->refreshMetaData();
                $actionclass=$actionclass->findByPk($available_action->action);
                if ($user!=NULL) {
                    $actionclass->refresh();
                    switch ($actionclass->registry) {
                        case FFModel::route_action_for_user:
                            $users=$actionclass->getItems("users");
                            foreach ($users as $userItem) {
                                if ($user==$userItem->id) {
                                    $findIt=TRUE;
                                    break;
                                }
                            }
                            break;
                        case FFModel::route_action_for_role:
                            $roles=$actionclass->getItems("roles");
                            foreach ($roles as $roleItem) {
                                if ($roleId==$roleItem->id) {
                                    $findIt=TRUE;
                                    break;
                                }
                            }
                            break;
                    }                                    
                }
                if (($user==NULL) || ($findIt))
                    $result=array_merge($result,array($actionclass));
            }
        }
        $result=array_unique($result);
        return $result;
    }
    
    /// Допустимые действия для документа в папке
    public function getActionsFromFolder($folderid, $userId=null) {
        $result=array();
        // Ищем роль для указанного пользователя
        $roleId=NULL;
        if ($userId!=null) {
            $_user=new FFModel();
            $_user->registry=FFModel::user;
            $_user->refreshMetaData();
            $_user=$_user->findByPk($userId);
            if (isset($_user) && ($_user!=NULL)) $roleId=$_user->user_roles_id;
            else return null;
        }        
        $folder =new folder_route_FFModel();
        $folder->registry=  FFModel::route_folder;
        $folder->refreshMetaData();
        $folder=$folder->findByPk($folderid);
//        $folder->refresh();
        $nodes=$folder->getItems("nodes");
        if (!isset($nodes) || $nodes==null) return NULL;        
        $available_actions=$this->getItems("available_actions");       
        if (!isset($available_actions) || $available_actions==null) return NULL;
        foreach ($available_actions as $available_action) {
            foreach ($nodes as $node) {
                if ($available_action->node==$node->id) {
                    $actionclass=new actions_route_FFModel();
                    $actionclass->registry=  FFModel::route_action;
                    $actionclass->refreshMetaData();
                    $actionclass=$actionclass->findByPk($available_action->action);
                    $findIt=FALSE;
                    if ($userId!=NULL) {
                        $actionclass->refresh();
                        switch ($available_action->registry) {
                            case FFModel::available_actions_for_user:
                                $users=$actionclass->getItems("users");
                                foreach ($users as $userItem) {
                                    if ($userId==$userItem->id) {
                                        $findIt=TRUE;
                                        break;
                                    }
                                }
                                break;
                            case FFModel::available_actions_for_role:
                                $roles=$actionclass->getItems("roles");
                                foreach ($roles as $roleItem) {
                                    if ($roleId==$roleItem->id) {
                                        $findIt=TRUE;
                                        break;
                                    }
                                }
                                break;
                            case FFModel::available_actions_for_cnap:
                                $roles=$actionclass->getItems("roles");
                                foreach ($roles as $roleItem) {
                                    if ($roleId==$roleItem->id) {
                                        $findIt=TRUE;
                                        break;
                                    }
                                }
                                if ($findIt) break;
                                $users=$actionclass->getItems("users");
                                foreach ($users as $userItem) {
                                    if ($userId==$userItem->id) {
                                        $findIt=TRUE;
                                        break;
                                    }
                                }                                
                                break;
                            default :
                                $findIt=TRUE;
                        }    
                    }
                    if (($userId==NULL) || ($findIt))
                        $result=array_merge($result,array($actionclass));
                }                
            }
        }
//        if (count($result)>0) $result=array_unique($result);
        return $result;
    }
    
    // Показывает доступно ли действие в папке
    public function enableAction($folderid, $actionId, $userId=null) {
        $roleId=NULL;
        if ($userId!=null) {
            $_user=new FFModel();
            $_user->registry=FFModel::user;
            $_user->refreshMetaData();
            $_user=$_user->findByPk($userId);
            if (isset($_user) && ($_user!=NULL)) $roleId=$_user->user_roles_id;
            else return FALSE;
        }    
        $avaibleactions=$this->getItems("available_actions");
        if (empty($avaibleactions) || $avaibleactions==null || count($avaibleactions)==0) return FALSE;
        $folder= new FFModel;
        $folder->registry=  FFModel::route_folder;
        $folder->refreshMetaData();
        $folder=$folder->findByPk($folderid);
        if (empty($folder) || $folder==null) return FALSE;
        $nodes=$folder->getItems("nodes");
        if (empty($nodes) || $nodes==null || count($nodes)==0) return FALSE;        
        foreach ($nodes as $node) {
            foreach ($avaibleactions as $avaibleaction) {
                if ($node->id==$avaibleaction->node && $avaibleaction->action==$actionId) {
                    if ($userId!=NULL) {
                        switch ($avaibleaction->registry) {
                        case FFModel::available_actions_for_user:
                            $avaibleaction->refresh();
                            $users=$avaibleaction->getItems("users");
                            foreach ($users as $_user) {
                                if ($_user->id==$userId) return TRUE;
                            }
                            return FALSE;
                            break;
                        case FFModel::available_actions_for_role:
                            if ($roleId==NULL) return FALSE;
                            $avaibleaction->refresh();
                            $roles=$avaibleaction->getItems("roles");
                            foreach ($roles as $_role) {
                                if ($_role->id==$roleId) return TRUE;
                            }
                            return FALSE;
                            break;
                        default :
                           // Сомнительно
                           return TRUE;                           
                        }
                    } else return TRUE;  
                }
            }
           
        }
//        $actions=  $this->getActionsFromFolder($folderid, $user);
//        if (!isset($actions) || $actions==null) return FALSE;
//        foreach ($actions as $action) {
//            if ($action->id==$actionId) return TRUE;
//        }
        return FALSE;
    }
    
    // Применяет действие к документу
    public function applyAction($actionId, $userId=NULL) {   
        $roleId=NULL;
        $roles=array();
        $users=array();
        if ($userId!=null) {
            $_user=new FFModel();
            $_user->registry=FFModel::user;
            $_user->refreshMetaData();
            $_user=$_user->findByPk($userId);
            if (isset($_user) && ($_user!=NULL)) $roleId=$_user->user_roles_id;
            else return FALSE;
        }        
        // Разрешенные узлы
        $available_nodes=$this->getItems("available_nodes");        
        if (!isset($available_nodes) || $available_nodes==null) return $available_nodes=array();
        // Загружаем действие
        $action=new actions_route_FFModel();
        $action->registry=  FFModel::route_action;
        $action->refreshMetaData();
        $action=$action->findByPk($actionId);
        $action->refresh();
        // Устанавливаем поля при выполнении действия
        if ($action->hasAttribute("setfields") && $action->getAttribute("setfields")!="") {
            $setfields=  explode(";", trim($action->getAttribute("setfields")));
            Yii::import("mff.components.utils.PathUtil");
            $pu=new PathUtil($this);
            $this->refresh();
            foreach ($setfields as $parafield) {
                $parafieldkeys=explode("=", $parafield);
                if (count($parafieldkeys)!=2) continue;
                $type=$this->getType($parafieldkeys[0]);
                $value=$pu->getValue($parafieldkeys[1]);
                if ($type->view=="listbox_multi") {
                    $this->setMultiGuide($parafieldkeys[0], array($value));
                } else
                    if ($this->hasAttribute($parafieldkeys[0])) {                       
                        $this->setAttribute(trim($parafieldkeys[0]),$value);
                    }
            }
            $this->save();
        }
        // Определяем список пользователей или ролей
        $registry_available_nodes=FFModel::available_nodes;
        $registry_available_actions=FFModel::available_actions;
        // Читаем текущего пользователя
        if ($action->getAttribute("currentuser")=='1')
            $users=array_merge($users,array($userId));
        if ($action->getAttribute("currentrole")=='1' && $roleId!=null)
            $roles=array_merge($roles,array($roleId));        
        // Читаем из действи перечень ролей
  
        $_roles=$action->getItems("roles");
        if (isset($_roles) && $_roles!=NULL) {
            foreach ($_roles as $_role) {
                $roles=array_merge($roles,array($_role->id));
            }            
        }     
        $_users=$action->getItems("users");
        if (isset($_users) && $_users!=NULL) {
            foreach ($_users as $_user) {
                $users=array_merge($users,array($_user->id));
            }               
        }
        $clearuser=FALSE;
        $authorities=null;       
        // Устанавливаем константы
        if ($action->registry==FFModel::route_action_for_role){
            $registry_available_nodes=FFModel::available_nodes_for_role;
            $registry_available_actions=FFModel::available_actions_for_role;
        }
        if ($action->registry==FFModel::route_action_for_user){            
            $registry_available_nodes=FFModel::available_nodes_for_user;
            $registry_available_actions=FFModel::available_actions_for_user;
        }
        if ($action->registry==FFModel::route_action_for_cnap){            
            $registry_available_nodes=FFModel::available_nodes_for_cnap;
            $registry_available_actions=FFModel::available_actions_for_cnap;
            $clearuser=($action->getAttribute("clearuser")=='1')?TRUE:FALSE;
            $current_authorities=$action->getAttribute("current_authorities");
            if (isset($current_authorities) && $current_authorities!=null && $current_authorities!=''){
                $authorities=$this->getAttribute($current_authorities);
                if (isset($authorities) && $authorities!=null) {
                    $_users= new FFModel();
                    $_users->registry=  FFModel::user;
                    $_users->refreshMetaData();
                    $_users=$_users->findAll("authorities_id=".$authorities);
                    foreach ($_users as $_user) {
                        $users=array_merge($users,array($_user->id));
                    }
                }
            }
        }
        // Загружаем список очистки        
        $clearnodes=$action->getItems("clearnodes");
        
        if (isset($clearnodes) && $clearnodes!=null) {
        // Очищаем узлы согластно действию
            $index=0;
            foreach ($available_nodes as $available_node) {                
                foreach ($clearnodes as $node) {
                    if ($available_node->node == $node->id) {
                        if ($clearuser) {
                            $available_node->refresh();
                            $_users=$available_node->getItems("users");
                            if (isset($_users) && $_users!=null) {
                                foreach ($_users as $_user) {
                                    $users=array_merge($users,array($_user->id));
                                }
                            }
                        }                
                        $available_node->delete();
                        unset($available_nodes[$index]);
                    }
                    else $index++;
                }           
            }
        }
        
        // Считываем узлы которые необходимо добавить
        $gotonodes=$action->getItems("gotonodes");
        if ($gotonodes==NULL) $gotonodes=array();
        // Убираем те узлы которые уже присутствуют
        
        foreach ($gotonodes as $index=>$node) {
            foreach ($available_nodes as $available_node) {
                if ($node->id==$available_node->node) {
                    unset($gotonodes[$index]);
                }
            }            
        }
        
        // Добавляем в добавляемые узлы те узлы которые уже есть
        foreach ($available_nodes as $available_node) {
            $node=new nodes_route_FFModel();
            $node->registry=  FFModel::route_node;
            $node->refreshMetaData();
            $node=$node->findByPk($available_node->node);
            $gotonodes=array_merge($gotonodes,array($node));
        }       
        
        $available_nodeIds=array();
        $available_actionIds=array();
        $available_actions=$this->getItems("available_actions");
                
        // Добавляем в допустимые узлы - новые узлы               
        foreach ($gotonodes as $node) {
            $skip=FALSE;
            foreach ($available_nodes as $available_node) {
                if ($node->id==$available_node->node) {
                    $available_nodeIds=  array_merge($available_nodeIds, array($available_node->id));
                    $skip=TRUE;
                    break;
                }
            }
            if (!$skip) {
                $available_nodesclass=new available_nodes_route_FFModel();
                $available_nodesclass->registry=$registry_available_nodes;
                $available_nodesclass->refreshMetaData();  
                $available_nodesclass->storage=FFModel::available_nodes_storage;
                $available_nodesclass->node = $node->id;               
                // Сохраняем
                $available_nodesclass->save();
                $available_nodeIds=array_merge($available_nodeIds,array($available_nodesclass->id));
                // Определить пользователя или роль
                switch ($registry_available_nodes) {
                    case FFModel::available_nodes_for_role:
                        $available_nodesclass->setMultiGuide("roles", $roles);    
                        break;
                    case FFModel::available_nodes_for_user:
                        $available_nodesclass->setMultiGuide("users", $users);    
                        break;
                    case FFModel::available_nodes_for_cnap:
                        $available_nodesclass->setMultiGuide("users", $users);
                        $available_nodesclass->setMultiGuide("roles", $roles);  
//                        $available_nodesclass->setAttribute("authorities", $authorities);  
                        break;
                }      
            }
            // Допустимые действия                
            $allow_actions = $node->getItems("allow_action");
            $deny_actions = $node->getItems("deny_action");
 
            // Очищаем список
            foreach ($deny_actions as $deny_action) {
                foreach ($available_actions as $index=>$available_action ) {
                    if ($available_action->action==$deny_action->id) {
                        $available_action->delete();
                        unset($available_actions[$index]);
                    }
                }
            }
            foreach ($available_actions as $available_action) {
                $available_actionIds=array_merge($available_actionIds,array($available_action->id));
            }
            /// Переписываем старые допустимые действия
            foreach ($allow_actions as $allow_action) { 
                $skip=FALSE;
                foreach ($available_actions as $available_action) {
                    if ($available_action->action==$allow_action->id) {
                        $available_actionIds=array_merge($available_actionIds, array($available_action->id));
                        $skip=TRUE;
                        break;
                    }
                }
                if (!$skip) {
                    // Добавляем номое действие
                    $available_actionsclass=new available_actions_route_FFModel();
                    $available_actionsclass->registry=$registry_available_actions;
                    $available_actionsclass->refreshMetaData();  
                    $available_actionsclass->storage=FFModel::available_actions_storage;
                    $available_actionsclass->node = $node->id;   
                    $available_actionsclass->action = $allow_action->id;   
                    // Сохраняем
                    $available_actionsclass->save();
                    $available_actionIds=array_merge($available_actionIds,array($available_actionsclass->id));
                    // Определить пользователя или роль
                    switch ($registry_available_actions) {
                        case FFModel::available_actions_for_role:
                            $available_actionsclass->setMultiGuide("roles", $roles);    
                            break;
                        case FFModel::available_actions_for_user:
                            $available_actionsclass->setMultiGuide("users", $users);    
                            break;
                        case FFModel::available_actions_for_cnap:
                            $available_actionsclass->setMultiGuide("users", $users);
                            $available_actionsclass->setMultiGuide("roles", $roles);  
//                            $available_actionsclass->setAttribute("authorities", $authorities);  
                            break;
                    }  
                }
            }            
        }
         // Устанавливаем в текущем документе привязку к узлам
        $this->setMultiGuide("available_nodes",$available_nodeIds);
        // Устанавливаем разрешенные действия на документе
        $this->setMultiGuide("available_actions",$available_actionIds);
        return TRUE;
    }
}


/// Временый класс для справочников
class fieldlist_FFModel extends FFModel {} 
/// Временый класс для справочников
class subguide_FFModel extends FFModel {} 

class ref_multiguide_FFModel extends FFModel {} 

class route_FFModel extends FFModel {} 
class available_nodes_route_FFModel extends FFModel {} 
class nodes_route_FFModel extends FFModel {} 
class available_actions_route_FFModel extends FFModel {} 
class actions_route_FFModel extends FFModel {} 
class folder_route_FFModel extends FFModel {} 


