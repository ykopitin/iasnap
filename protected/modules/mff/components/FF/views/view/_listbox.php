<?php
try{
    // вычисляем хранилище в зависимости от типа данных
    $storageitem=FFStorage::model()->find("type=:type", array(":type"=>$data->typeItem->id));
    if ($scenario=="view") {
    $id=$modelff->getAttribute(strtolower($data->name));
    if ($id!=null) {
        $modelclassif = fieldlist_FFModel::model()->findByPk($id);
        if (isset($modelclassif) && $modelclassif!=null) {
            $modelclassif->refreshMetaData();
            $modelclassif->refresh();
            echo CHtml::label($modelclassif->name,"") ;
        }
    }
    return;      
    }
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
    $sizecount=count($listdata);
    $sizecount=($sizecount>10)?10:$sizecount;
    $sizecount=($sizecount<2)?2:$sizecount;
    $dropDownListOptions=array(
        "style"=>"width:100%", 
        "size"=>$sizecount, 
        "multiple"=>"multiple", 
        "onkeypress"=>"listbox_keypress(event,this);");
    if ($scenario=="view") $dropDownListOptions=array_merge($dropDownListOptions,array("disabled"=>"disabled"));
    echo CHtml::dropDownList("multiguide_".$data->id, $selectdata,$listdata,$dropDownListOptions);
} catch (Exception $e){
     echo 'Не удалось загрузить поле:\n'.$e->getMessage();
}
