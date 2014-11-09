<?php
try{
    Yii::app()->clientScript->registerScriptFile(Yii::app()->createUrl("/mff/default/getscript",array("script"=>basename(__FILE__,".php"))));
    // вычисляем хранилище в зависимости от типа данных
    $storageitem=FFStorage::model()->find("type=:type", array(":type"=>$data->typeItem->id));    
    $listdata=array();
    foreach ($storageitem->registryItems as $registryItem) {
        $v_FFModel=new fieldlist_FFModel;
        $v_FFModel->registry=$registryItem->id;
        $v_FFModel->refreshMetaData();
        if ($v_FFModel->getAttaching()==0) {
            $v_FFModel->storage=$storageitem->id;
            $modelclassif = $v_FFModel->findAll("storage=:storage and registry=:registry",array(":storage"=>$storageitem->id,":registry"=>$registryItem->id));
            $listdata = $listdata+CHtml::listData($modelclassif, "id", "name");         
        } else {
            if (empty($storageitem->fields) || $storageitem->fields==NULL || $storageitem->fields=="") {
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
            } else {
                
                $columns=explode(";", $storageitem->fields);                
                $modelclassif = $v_FFModel->findAll();
                foreach ($modelclassif as $model) { 
                    $listdatavalue="";
                    foreach ($columns as $column) {
                        $column=explode(":", $column);
                        switch (count($column)) {
                        case 1:
                            if ($listdatavalue=="") {
                                $listdatavalue=$model->getAttribute($column[0]); 
                            } else {
                                $listdatavalue.="; ".$model->getAttribute($column[0]); 
                            }
                            break;
                        case 2:
                            if ($listdatavalue=="") {
                                $listdatavalue=$column[1].": ".$model->getAttribute($column[0]); 
                            } else {
                                $listdatavalue.="; ".$column[1].": ".$model->getAttribute($column[0]); 
                            }
                            break;
                        }
                    }
                    $listdata[$model->id]=$listdatavalue;
                }
            }
        }
    }
    $selectdata=array();    
    if (($scenario=="view") || ($scenario=="update")) {          
        $modelclassif = $modelff->getItems($data->name);       
        foreach ($modelclassif as $value) {
           $selectdata = array_merge($selectdata,array($value->id));   
        }      
    }
    $sizecount=count($listdata);
    $sizecount=($sizecount>10)?10:$sizecount;
    $sizecount=($sizecount<2)?2:$sizecount;
    $dropDownListOptions=array(
        "size"=>$sizecount, 
        "multiple"=>"multiple", 
        "onkeypress"=>"listbox_multi_keypress(event,this);");
    $dropDownListOptions=array_merge($dropDownListOptions,$htmlOptions);
    if ($scenario=="view") $dropDownListOptions=array_merge($dropDownListOptions,array("disabled"=>"disabled"));
    echo CHtml::dropDownList("multiguide_".$data->name, $selectdata,$listdata,$dropDownListOptions);
} catch (Exception $e){
     echo 'Не удалось загрузить поле:\n'.$e->getMessage();
}