<?php
echo '<p style="font-style: italic;">'.$folder->getAttribute("comment")."</p>";
$userId=Yii::app()->User->id;
if (!is_numeric($userId)) $userId='null';
$storageItems_new=$folder->getItems("allow_new");
$storageItems_new_deny=$folder->getItems("deny_new");

$storageItems_edit=$folder->getItems("allow_edit");
$storageItems_delete=$folder->getItems("allow_delete");
$buttons=array(
    'view'=>
        array(
            'visible'=>'true',
            'url'=>'Yii::app()->createUrl("/mff/formview/save", 
                    array(
                        "idregistry"=>$data->registry,
                        "idstorage"=>$data->storage,
                        "idform"=>$data->id,
                        "scenario"=>"view",
                        "thisrender"=>"'.base64_encode("mff.views.cabinet.cabinet").'",
                        "addons"=>"'.base64_encode('array("cabinetid"=>'.$cabinet->id.')').'",'.    
                        ')
                    )'          
            ),
    'update'=>
        array(
            'visible'=>'false',
            'url'=>'Yii::app()->createUrl("/mff/formview/save", 
                    array(
                        "idregistry"=>$data->registry,
                        "idstorage"=>$data->storage,
                        "idform"=>$data->id,
                        "scenario"=>"update",
                        "thisrender"=>"'.base64_encode("mff.views.cabinet.cabinet").'",
                        "addons"=>"'.base64_encode('array("cabinetid"=>'.$cabinet->id.')').'",'.
                        ')
                    )'          
            ),
    'delete'=>
        array(
            'visible'=>'false',
            'url'=>'Yii::app()->createUrl("/mff/formview/delete", 
                    array(
                        "idform"=>$data->id,
                        "backurl"=>"'.base64_encode(Yii::app()->createUrl("/mff/cabinet/cabinet",array("id"=>$cabinet->id))).'",'.
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
if (count($storageItems_new)>0) {
    $items=array();
    $storageItemIds=array();
    foreach ($storageItems_new as $storageItem) {
        $storageItem=FFStorage::model()->findByPk($storageItem->id); // Чтобы не терять
        foreach ($storageItem->registryItems as $registryItem) {
            if (in_array($registryItem->id, $storageItemIds)) continue;;
            $storageItemIds=  array_merge($storageItemIds,array($registryItem->id));
            $skip=FALSE;
            foreach ($storageItems_new_deny as $storageItem_new_deny) {
                if ($storageItem_new_deny->id==$registryItem->id) {
                    $skip=TRUE;
                    break;
                }
            }
            if ($skip) continue;
            $label = "Зареєструвати: ".$registryItem->getAttribute("description");
            $url=$this->createUrl(
                    "/mff/formview/save", 
                    array(
                        "idregistry"=>$registryItem->id,
                        "idstorage"=>$storageItem->id,
                        "thisrender"=>base64_encode("mff.views.cabinet.cabinet"),
//                        "backurl"=>base64_encode(Yii::app()->createUrl("/mff/cabinet/cabinet",array("id"=>$cabinet->id))),
                        "addons"=>base64_encode('array("cabinetid"=>'.$cabinet->id.')')));
            $items=array_merge($items,array(array("label"=>$label,"url"=>$url)));                    
        }
    }
    $this->widget("zii.widgets.CMenu",array("items"=>$items,"htmlOptions"=>array("id"=>"menucreate")));
}
// Узлы папки
$nodes=$folder->getItems("nodes");
if (count($nodes)==0) {
    return;
}
$nodeIds=array();
foreach ($nodes as $node) {
    $nodeIds=array_merge($nodeIds,array($node->id));
}
// Узлы формы (ИД допустимых узлов)

$availableNode=new FFModel;
$availableNode->registry=  FFModel::available_nodes;
$availableNode->refreshMetaData();
$availableNodeCriteria = new CDbCriteria();
$availableNodeCriteria->addInCondition("node", $nodeIds);
$availableNodes=$availableNode->findAll($availableNodeCriteria);
if (count($availableNodes)==0) {
    return;
}
$nodeIds=array();
foreach ($availableNodes as $node) {
    $nodeIds=array_merge($nodeIds,array($node->id));
}
// Определение форм
$refDocument=new FFModel;
$refDocument->registry=  FFModel::ref_multiguide;
$refDocument->refreshMetaData();
$refDocumentCriteria = new CDbCriteria();
$refDocumentCriteria->select="ref.`owner`";
$refDocumentCriteria->addInCondition("ref.`reference`", $nodeIds);
$refDocumentCriteria->alias = "ref";
$refDocuments=$refDocument->findAll($refDocumentCriteria);
$idDocuments=array();
foreach ($refDocuments as $refDocument) {
    $idDocuments=  array_merge($idDocuments, array($refDocument->owner));
}
$documents=FFModel::model()->findAllByPk($idDocuments);
// Теперь фильтруем по полю
$idDocuments=array();
$registryDocuments=array();
for ($index = 0; $index < count($documents); $index++) {
    $documents[$index]->refresh();
    $field=$documents[$index]->getField("available_nodes");
    if (isset($field) && $field!=NULL) {
        $idDocuments=  array_merge($idDocuments, array($documents[$index]->id));
        $registryDocuments=  array_merge($registryDocuments, array($documents[$index]->registry));
    }   
}
//$registryDocuments=array_unique($registryDocuments,SORT_NUMERIC);
echo CHtml::hiddenField("folder_".$folder->id,count($idDocuments));

// Определение списка действий
// отбираем все действия
$templateButton=" {view} {update} {delete}";
$ActionList=$folder->getItems("allow_action");
foreach ($ActionList as $ActionItem) {
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
                        "cabinetid"=>'.$cabinet->id.',
                        "actionid"=>'.$ActionItem->id.',
                        "documentid"=>$data->id,
                        "folderid"=>'.$folder->id.'
                        )
                    )'          
            )
        );
    $templateButton = ' {action'.$ActionItem->id.'}'.$templateButton;
    $buttons = array_merge($buttonItem,$buttons);
}
// Определение колонок
$columns = array(array('name'=>'id',"headerHtmlOptions"=>array("style"=>"width:60px"),'filter'=>''));
if (strlen($folder->getAttribute("visual_names"))>0) {
   $columnVisualNames = explode(";",$folder->visual_names);
   foreach ($columnVisualNames as $columnVisual) {
       if (trim($columnVisual)=="") continue;
       $columnVisualList=explode(":", $columnVisual);
       if (count($columnVisualList)==0) continue;
       $columnVisualName=$columnVisualList[0];
       if (count($columnVisualList)>1) $columnVisualTitle=$columnVisualList[1];
       else $columnVisualTitle=$columnVisualName;
       // сюда можно добавить отображение сложных полей
       $columns = array_merge($columns,array(array('name'=>$columnVisualName,"header"=>$columnVisualTitle)));
   }
}
$columns = array_merge($columns, array(array('class'=>'mff.components.mffButtonColumn', 'htmlImageOptions'=>array('style'=>"width:16px"), "headerHtmlOptions"=>array("style"=>"width:100px"), "template"=>$templateButton, "header"=>"Дії", 'buttons'=>$buttons)));

// Отображение грида
$documentCriteria = new CDbCriteria();
$documentCriteria->addInCondition("id", $idDocuments);
$model=new FFModel();
$commonP=FFModel::commonParent($registryDocuments);
$model->registry=  $commonP;
$model->refreshMetaData();
$dp=new CActiveDataProvider($model, 
                    array(
                        'criteria'=>$documentCriteria,
                        'pagination' => array(
                            'pageSize' => 10,
                            )
                        )
                    );

$this->widget("mff.components.mffGridView",
        array(
            "dataProvider"=>$dp, 
            "enablePagination"=>TRUE,
            'columns'=>$columns,
        ));

?>
<script type="text/javascript">
    $.ready($("#counter<?= $folder->id?>").html($("#folder_<?= $folder->id?>").val()));
</script>