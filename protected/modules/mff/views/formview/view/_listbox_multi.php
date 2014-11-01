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
        if ($v_FFModel->getAttaching()==0) {
            $modelclassif = $v_FFModel->findAll("storage=:storage and registry=:registry",array(":storage"=>$storageitem->id,":registry"=>$registryItem->id));
            $listdata = $listdata+CHtml::listData($modelclassif, "id", "name");         
            $v_FFModel->registry=1;
            $v_FFModel->refreshMetaData();
        } else {
            $columns=$v_FFModel->getTableSchema()->columns; 
            $modelclassif = $v_FFModel->findAll();
            foreach ($modelclassif as $model) { 
                $listdatavalue="";
                foreach ($columns as $column) {                     
                    if ($column->type=="string") {
                        if ($listdatavalue=="") {
                            $listdatavalue=$column->name.": ".$model->getAttribute($column->name); 
                        } else {
                            $listdatavalue.="; ".$column->name.": ".$model->getAttribute($column->name); 
                        }
                    }
                }
                $listdata[$model->id]=$listdatavalue;
            }           
            
        }
    }
    $selectdata=array();
    
    if (($scenario=="view") || ($scenario=="update")) {  
        $v_FFModel=new fieldlist_FFModel;
        $v_FFModel->registry=fieldlist_FFModel::ref_multiguide;
        $v_FFModel->refreshMetaData();
        $criteria=new CDbCriteria();
        $criteria->addCondition("`storage`=:storage");
        $criteria->addCondition("`owner`=:owner");
        $criteria->addCondition("`owner_field`=:owner_field");
        $criteria->addCondition("`registry`=:registry");
        $criteria->params = array(
            ":storage"=>fieldlist_FFModel::ref_multiguide_storage,
            ":registry"=>fieldlist_FFModel::ref_multiguide,
            ":owner"=>$modelff->id, 
            ":owner_field"=>$data->id
        );
        $criteria->order = "`order`";
        $modelclassif = $v_FFModel->findAll($criteria);
        foreach ($modelclassif as $value) {
           $selectdata = array_merge($selectdata,array($value->reference));   
        }      
    }
    $sizecount=count($listdata);
    $sizecount=($sizecount>10)?10:$sizecount;
    $sizecount=($sizecount<2)?2:$sizecount;
    $dropDownListOptions=array(
        "style"=>"width:100%", 
        "size"=>$sizecount, 
        "multiple"=>"multiple", 
        "onkeypress"=>"listbox_multi_keypress(event,this);");
    if ($scenario=="view") $dropDownListOptions=array_merge($dropDownListOptions,array("disabled"=>"disabled"));
    echo CHtml::dropDownList("multiguide_".$data->id, $selectdata,$listdata,$dropDownListOptions);
} catch (Exception $e){
     echo 'Не удалось загрузить поле:\n'.$e->getMessage();
}