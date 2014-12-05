<?php

if ($this instanceof CWidget) {
    $controller=$this->getOwner();
    $ffcontroller="/usl/save";
} else {
    if (get_class($this->getModule())=="MffModule") {
        $controller=$this;
        $ffcontroller="/mff/formview/save";
    } else {
        $controller=$this;
        $ffcontroller="/usl/save";
    }
}

//echo '<p style="font-style: italic;">'.$folder->getAttribute("comment")."</p><hr />";
$userId=Yii::app()->User->id;
if (!is_numeric($userId)) $userId='null';
$roleId=NULL;
$authoritie=NULL;
$fielddefault='';
if ($userId!='null') {
    $user=new FFModel;
    $user->registry=  FFModel::user;
    $user->refreshMetaData();
    $user=$user->findByPk($userId);
    $roleId=$user->user_roles_id;
    $authoritie=$user->authorities_id;
    if ($user->getAttribute("user_roles_id")=='2') {
        $fielddefault='"fielddefaults"=>array("route"=>"1742")';
    }
}

$storageItems_new=$folder->getItems("allow_new");
$storageItems_new_deny=$folder->getItems("deny_new");

$storageItems_edit=$folder->getItems("allow_edit");
$storageItems_delete=$folder->getItems("allow_delete");

$hideaction = FALSE; 
if ($folder->hasAttribute("hideaction") && $folder->getAttribute("hideaction")=='1') {
    $hideaction = TRUE;
}
if (!$hideaction) {
    $buttons=array(
        'view'=>
            array(
                'visible'=>'true',
                'url'=>'Yii::app()->createUrl("'.$ffcontroller.'", 
                        array(
                            "idregistry"=>$data->registry,
                            "idstorage"=>$data->storage,
                            "idform"=>$data->id,
                            "scenario"=>"view",
                            "backurl"=>"'.$backurl.'",
                            "thisrender"=>"'.$cabineturl.'",
                            "addons"=>"'.base64_encode('array("cabinetid"=>'.$cabinet->id.',"folderid"=>'.$folder->id.')').'",'.    
                            ')
                        )'          
                ),
        'update'=>
            array(
                'visible'=>'false',
                'url'=>'Yii::app()->createUrl("'.$ffcontroller.'", 
                        array(
                            "idregistry"=>$data->registry,
                            "idstorage"=>$data->storage,
                            "idform"=>$data->id,
                            "scenario"=>"update",
                            "backurl"=>"'.$backurl.'",
                            "thisrender"=>"'.$cabineturl.'",
                            "addons"=>"'.base64_encode('array("cabinetid"=>'.$cabinet->id.',"folderid"=>'.$folder->id.')').'",'.
                            ')
                        )'          
                ),
        'delete'=>
            array(
                'visible'=>'false',
                'url'=>'Yii::app()->createUrl("/mff/formview/delete", 
                        array(
                            "idform"=>$data->id,
                            "backurl"=>"'.$backurl.'",'.
                            ')
                        )'          
                ),
        ); 

    if (count($storageItems_edit)>0) {
        $buttons["update"]["visible"]="true";
    }
    if (count($storageItems_delete)>0) {
        $buttons["delete"]["visible"]="true";
    }
}
if (count($storageItems_new)>0) {
    $items=array();
    $storageItemIds=array();
    echo "<p>".CHtml::label("Обрати послугу ", "")."</p>";
    $datalist=array();
    foreach ($storageItems_new as $storageItem) {
        $storageItem=FFStorage::model()->findByPk($storageItem->id); // Чтобы не терять
        foreach ($storageItem->registryItems as $registryItem) {
            if (in_array($registryItem->id, $storageItemIds)) continue;
            $storageItemIds=  array_merge($storageItemIds,array($registryItem->id));
            $skip=FALSE;
            foreach ($storageItems_new_deny as $storageItem_new_deny) {
                if ($storageItem_new_deny->id==$registryItem->id) {
                    $skip=TRUE;
                    break;
                }
            }
            if ($skip) continue;
            $label = $registryItem->getAttribute("description");
            $url=$this->createUrl(
                    $ffcontroller, 
                    array(
                        "idregistry"=>$registryItem->id,
                        "idstorage"=>$storageItem->id,
                        "thisrender"=>$cabineturl,
                        "backurl"=>$backurl,
                        "addons"=>base64_encode('array("cabinetid"=>'.$cabinet->id.',"folderid"=>'.$folder->id.','.$fielddefault.')')));
            $datalist=array_merge($datalist, array($url=>$label));
        }
    }
    echo CHtml::dropDownList("selectservice", NULL, $datalist)." <br /><br />";
    $this->widget(
            "zii.widgets.jui.CJuiButton",
            array(
                'buttonType'=>'button',
                'name'=>'btnSave',
                'caption'=>'Нова заявка',
                'onclick'=>new CJavaScriptExpression('function(){window.location=selectservice.options[selectservice.selectedIndex].value; return false;}')));
//    $this->widget("zii.widgets.CMenu",array("items"=>$items,"htmlOptions"=>array("id"=>"menucreate")));
}

//$registryDocuments=array_unique($registryDocuments,SORT_NUMERIC);
echo CHtml::hiddenField("folder_".$folder->id,count($documentIds));
if ( !$hideaction) {
    // Определение списка действий
    // отбираем все действия
    $templateButton=" {view} {update} {delete}";

    $ActionItems= new FFModel();
    $ActionItems->registry=  FFModel::route_action;
    $ActionItems->refreshMetaData();
    $ActionItems=$ActionItems->findAll("storage=:storage",array(":storage"=>  FFModel::route_action_storage));

    foreach ($ActionItems as $ActionItem) {
    //    $ActionItem->refresh();

        $buttonItem=array(
           'action'.$ActionItem->id=>array(
                'visible'=>'$data->enableAction('.$folder->id.','.$ActionItem->id.','.$userId.')',
                'label'=>$ActionItem->name,
                'imageUrl'=>$this->createUrl("/mff/default/getimage",array("image"=>"Flag")),
    //            'imageUrl'=>$this->createUrl("/mff/default/getimage",array("image"=>"Gears")),
    //            "options"=>array("style"=>"width:8px"),
                'url'=>'Yii::app()->createUrl("/mff/cabinet/doaction",
                        array(                    
                            "actionid"=>'.$ActionItem->id.',
                            "documentid"=>$data->id,                       
                            "userId"=>'.$userId.',
                            "cabineturl"=>"'. base64_encode(
                                    Yii::app()->createUrl(
                                            Yii::app()->request->getUrl(),
                                            array("folderid"=>$folder->id)
                                            )
                                    ).'",
                            )
                        )'          
                )
            );
        $templateButton .= ' {action'.$ActionItem->id.'}';
        $buttons = array_merge($buttons, $buttonItem);
    }
}
$documentCriteria = new CDbCriteria();
if (!(Yii::app()->request->isAjaxRequest && isset($_GET["FFModel_sort"])))
    $documentCriteria->order=" id DESC ";
$model=new FFModel();
$model->registry= FFModel::document_cnap;
$model->refreshMetaData();

$currentpage=0;
if(Yii::app()->request->isAjaxRequest) {
    if (isset($_GET[get_class($model)."_page"])) $currentpage=$_GET[get_class($model)."_page"];
    if (isset($_GET[get_class($model)])) {
        foreach ($_GET[get_class($model)] as $attribute => $value) {
            if (empty($value) || $value==null || $value=="") continue;
            $model->$attribute=$value;
            $documentCriteria->addSearchCondition($attribute, $value);
        } 
    }
    /// Поиск по трек номеру
    Yii::import("mff.components.utils.tracknumberUtil");
    $fields=  FFField::model()->findAll("formid=".FFModel::document_cnap." and `type`=8");
    $tracknumberset=FALSE;
    foreach ($fields as $field) {
        if (isset($_GET[$field->name])) {
            $tracknumber=$_GET[$field->name];
            if ($tracknumber!="") {
                if (tracknumberUtil::checkTracknumber($tracknumber)) {
                    $id=tracknumberUtil::getIdFromTracknumber($tracknumber);
                    $documentIdFound=FALSE;
                    foreach ($documentIds as $documentId) {
                        if ($documentId==$id) {
                            $documentIdFound=TRUE;
                            break;
                        }
                    }
                    if ($documentIdFound) {
                        $tracknumberset=TRUE;                  
                        $documentCriteria->addCondition("id=".$id);
                        break;
                    } else {
                        $documentCriteria->addCondition("0=1");
                    }
                } else {
                    $documentCriteria->addCondition("0=1");
                }
            }
        }
    }
    if (!$tracknumberset) {
        $documentCriteria->addInCondition("id", $documentIds);
    }
} else {
    $documentCriteria->addInCondition("id", $documentIds);
}

Yii::import("mff.components.utils.generatorFilter");
// Определение колонок
$columns = array(
//    array(
//        'name'=>'id',
//        "headerHtmlOptions"=>array("style"=>"width:60px"),'filter'=>'')
    );
if (strlen($folder->getAttribute("visual_names"))>0) {
   $columnVisualNames = explode(";",trim($folder->visual_names));
   foreach ($columnVisualNames as $columnVisual) {
       if (trim($columnVisual)=="") continue;
       $columnVisualList=explode(":", trim($columnVisual));
       if (count($columnVisualList)==0) continue;
       $columnVisualName=trim($columnVisualList[0]);
       if (count($columnVisualList)>1) $columnVisualTitle=trim($columnVisualList[1]);
       else $columnVisualTitle=trim($columnVisualName);
       // сюда можно добавить отображение сложных полей
       $columns = array_merge(
               $columns,
               array(
                   array(
                       'class'=>'mff.components.mffDataColumn',
                       'name'=>$columnVisualName,
                       'filter'=>generatorFilter::columnFilter($model, $columnVisualName),
                       "header"=>$columnVisualTitle)));
   }
}
if (! $hideaction) {
$columns = array_merge($columns, array(array('class'=>'mff.components.mffButtonColumn', 'htmlImageOptions'=>array('style'=>"width:16px"), "headerHtmlOptions"=>array("style"=>"width:100px"), "template"=>$templateButton, "header"=>"Дії", 'buttons'=>$buttons)));
}
// Отображение грида

$dp=new CActiveDataProvider($model, 
    array(
        'criteria'=>$documentCriteria,
        'pagination' => array(
            'pageSize' => 10,
            'currentPage'=>$currentpage,
            )
        )
    );

$this->widget("mff.components.mffGridView",
        array(
            "dataProvider"=>$dp, 
            'filter'=>$model,
            "enablePagination"=>TRUE,
            'columns'=>$columns,
            'cssFile'=>Yii::app()->baseUrl.'/css/folder.css',
        ));
        
?>
<script type="text/javascript">
    $.ready($("#counter<?= $folder->id?>").html($("#folder_<?= $folder->id?>").val()));
    
</script>
