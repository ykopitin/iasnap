<?php
try{
    Yii::app()->clientScript->registerScriptFile($this->createUrl("default/getscript",array("script"=>basename(__FILE__,".php"))));
    // вычисляем хранилище в зависимости от типа данных
    $storageitem=FFStorage::model()->find("type=:type", array(":type"=>$data->typeItem->id));    
    $listdata=array();
    foreach ($storageitem->registryItems as $registryItem) {
        $v_FFModel=new fieldlist_FFModel;
        $v_FFModel->registry=$registryItem->id;
        $v_FFModel->storage=$storageitem->id;
        $v_FFModel->refreshMetaData();
        $modelclassif = $v_FFModel->findAll("storage=:storage and registry=:registry",array(":storage"=>$storageitem->id,":registry"=>$registryItem->id));
        $listdata = $listdata+CHtml::listData($modelclassif, "id", "name");  
        $v_FFModel->registry=1;
        $v_FFModel->refreshMetaData();
    }
    $selectdata=array();
    
    if (($scenario=="view") || ($scenario=="update")) {   
        foreach ($storageitem->registryItems as $registryItem) {
            $v_FFModel=new fieldlist_FFModel;
            $v_FFModel->registry=$registryItem->id;
            $v_FFModel->storage=$storageitem->id;
            $v_FFModel->refreshMetaData();
            $criteria=new CDbCriteria();
            $criteria->alias="ffm";
            $criteria->addCondition("ffm.`storage`=:storage");
            $criteria->addCondition("ffm.`registry`=:registry");
            $criteria->join = 'INNER JOIN ff_ref_multiguide as ffrm ON ((ffrm.`owner`='.$modelff->id.') and (ffrm.`owner_field`=:owner_field) and (ffrm.`reference`=ffm.id))';
            $criteria->params = array(":storage"=>$storageitem->id,":registry"=>$registryItem->id, ":owner_field"=>$data->id);
            $criteria->order = "ffrm.`order`";
            $modelclassif = $v_FFModel->findAll($criteria);
            foreach ($modelclassif as $value) {
               $selectdata = array_merge($selectdata,array($value->id));   
            }            
        }
    }
    
    $sizecount=count($listdata);
    $sizecount=($sizecount>10)?10:$sizecount;
    $sizecount=($sizecount<2)?2:$sizecount;
    echo CHtml::dropDownList("multiguide_".$data->id, $selectdata,$listdata,array("style"=>"width:100%", "size"=>$sizecount, "multiple"=>"multiple", "onkeypress"=>"listbox_multi_keypress(event,this);"));
} catch (Exception $e){
     echo 'Не удалось загрузить поле:\n'.$e->getMessage();
}