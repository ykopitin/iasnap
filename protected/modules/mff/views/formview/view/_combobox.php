<?php
try{
    // вычисляем хранилище в зависимости от типа данных
    $storageitem=FFStorage::model()->find("type=:type", array(":type"=>$data->typeItem->id));
    // Вычисляем все модели
    $modelsdata = FFModel::model()->findAll("storage=:storage", array(":storage"=>$storageitem->id));
    for ($index = 0; $index < count($modelsdata); $index++) {
        $modelsdata[$index]->refreshMetaData();
    }        
    $listdata=  CHtml::listData($modelsdata, "id", "name");
    echo $form->dropDownList($modelff,$data->name,$listdata,array("style"=>"width:100%"));
} catch (Exception $e){
     echo 'Не удалось загрузить поле:\n'.$e->getMessage();
}
?>