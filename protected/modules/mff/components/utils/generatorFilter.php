<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of generatorFilter
 *
 * @author prk
 */
class generatorFilter {
    
    public static function columnFilter($model, $id) {
        $type=$model->getType($id);
        switch ($type->id) {
            case '1':
            case '2':
            case '4':
            case '5':
            case '6':
            case '11':
            case '12':
            case '15':
            case '16':
            case '18':
            case '19':
                return CHtml::activeTextField($model, $id);
                break;    
            case '8': // Трекномер
                $value="";
                if (Yii::app()->request->isAjaxRequest && isset($_GET[$id])) {
                    $value=$_GET[$id];
                }
                return CHtml::NumberField($id,$value, array("style"=>"width:60pt"));
                break;    
            case '3':
            case '7':
            case '17':               
                return CHtml::activeDateField($model, $id, array("style"=>"width:80pt"));
                break;
            default :
                switch ($type->getAttribute("view")){
                    case "combobox":
                    case "listbox":
                    case "innerguide":
                    case "radiobox":   
                            $storageitem=FFStorage::model()->find("type=:type", array(":type"=>$type->id));
                            $listdata=array(""=>null);       
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
                                        foreach ($modelclassif as $modelc) { 
                                            $listdatavalue="";
                                            foreach ($columns as $column) {                     
                                                if ($column->type=="string") {
                                                    if ($listdatavalue=="") {
                                                        $listdatavalue=$column->name.": ".$modelc->getAttribute($column->name); 
                                                    } else {
                                                        $listdatavalue.="; ".$column->name.": ".$modelc->getAttribute($column->name); 
                                                    }
                                                }
                                            }
                                            $listdata[$modelc->id]=$listdatavalue;
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
                                        foreach ($modelclassif as $modelc) { 
                                             $listdatavalue="";
                                            foreach ($columns as $column) {
                                                $column=explode(":", $column);
                                                switch (count($column)) {
                                                case 1:
                                                    if ($listdatavalue=="") {
                                                        $listdatavalue=$modelc->getAttribute($column[0]); 
                                                    } else {
                                                        $listdatavalue.="; ".$modelc>getAttribute($column[0]); 
                                                    }
                                                    break;
                                                case 2:
                                                    if ($listdatavalue=="") {
                                                        $listdatavalue=$column[1].": ".$modelc->getAttribute($column[0]); 
                                                    } else {
                                                        $listdatavalue.="; ".$column[1].": ".$modelc->getAttribute($column[0]); 
                                                    }
                                                    break;
                                                }
                                            }
                                            $listdata[$modelc->id]=$listdatavalue;
                                        }
                                    }
                                }   
                            }
                        return CHtml::activeDropDownList($model, $id, $listdata);
                        break;
                }
        }
        return "";
    }
}
