<?php
try{
    // вычисляем хранилище в зависимости от типа данных
    $storageitem=FFStorage::model()->find("type=:type", array(":type"=>$data->typeItem->id));
    $listdata=array(""=>"");       
    foreach ($storageitem->registryItems as $registryItem) {
        $v_FFModel=new fieldlist_FFModel;
        $v_FFModel->registry=$registryItem->id;
        $v_FFModel->refreshMetaData();
        if (($v_FFModel->getAttaching()==0) && (empty($storageitem->fields) || $storageitem->fields==NULL || $storageitem->fields=="")) {
            $v_FFModel->storage=$storageitem->id;
            $criteria=new CDbCriteria();
            $criteria->addCondition("storage=:storage and registry=:registry");
            $criteria->params=array(":storage"=>$storageitem->id,":registry"=>$registryItem->id);
            $criteria->order="`name`";
            $modelclassif = $v_FFModel->findAll($criteria);
            $listdata = $listdata+CHtml::listData($modelclassif, "id", "name");         
            $v_FFModel->registry=1;
            $v_FFModel->refreshMetaData();
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
                $criteria=new CDbCriteria();
                if ($v_FFModel->getAttaching()==0) {
                    $criteria->addCondition("storage=:storage");
                    $criteria->params[":storage"]=$storageitem->id;
                }
                if (count($columns)>0) {
                    $column=explode(":", $columns[0]);
                    $criteria->order="`".$column[0]."`";
                }
                $modelclassif = $v_FFModel->findAll($criteria);
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
    if ($scenario=="view") {          
        $id=$modelff->getAttribute(strtolower($data->name));
        echo CHtml::label($listdata[$id],"",$htmlOptions) ;
        return;      
    } else
    echo $form->dropDownList($modelff,$data->name,$listdata,$htmlOptions);
} catch (Exception $e){
     echo 'Не удалось загрузить поле:\n';
}
?>