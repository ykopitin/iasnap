<?php
$this->breadcrumbs=array(
    "Головна"=>array("/"),
    "Админка"=>array("/admin"),
    $this->module->label => array("/".$this->module->id),
    $this->label => array("/".$this->module->id."/".$this->id),
    $storagemodel->name=>$this->createUrl("indexstorage",array("id"=>$storagemodel->id)),
);
?> 
<h3>
<p><b>Хранилище:</b> <?= $storagemodel->name ?></p>
<p><i><?= $storagemodel->description ?></i></p>
</h3>
Доступные свободные формы:
<table>
    <?php
        
    foreach ($storagemodel->registryItems as $registrymodel) {
        ?>
    <tr>
        <td><?= CHtml::link("Зарегистрировать!",$this->createUrl("save",array("idregistry"=>$registrymodel->id,"idstorage"=>$storagemodel->id))) ?></td>
        <td><?= $registrymodel->tablename."(".$registrymodel->description.")" ?></td>
    </tr>
    <?php
    }
    ?>
</table>
<?php
$criteria=new CDbCriteria();
    $criteria->params[":storage"] = $storagemodel->id;
    $criteria->addCondition("storage = :storage");
    
$dataProvider=new CActiveDataProvider("FFModel", array(
        'criteria' => $criteria,
        'pagination' => array(
            'pageSize' => 30,
        )
    )
);
$registrylist=array();
foreach ($storagemodel->registryItems as $registryItem) {
    $registrylist= array_merge($registrylist,array($registryItem->id));
}
$vidregistry=FFModel::commonParent($registrylist); 
$columns="";
$columnnames=array();
if ($vidregistry!=null){
    $fields=FFField::model()->findAll("`formid`=$vidregistry and `type`<8 and `order`>0");  
    foreach ($fields as $field){
        $columns.="<th>$field->description</th>";
        $columnnames=  array_merge($columnnames , array($field->name));
    }
    $this->widget("zii.widgets.CListView", array(
        'dataProvider'=>$dataProvider,
        'itemView'=>'_indexstorage',
        'viewData'=>array("idstorage"=>$storagemodel->id,"idregistry"=>$registrymodel->id,"columnnames"=>$columnnames),
        'tagName'=>'table',
        'template'=>'<caption>{summary}</caption><thead><th>ID</th>'.$columns.
        '<th>Действия</th></thead>{items}',
        )
    );
}

if ($this->action->id=="save") {
    $urlparam=array("idregistry"=>$idregistry,"idstorage"=>$idstorage);
    if(isset($scenario)) {
        $urlparam=array_merge($urlparam,array("scenario"=>$scenario));
    }
    if(isset($idform)) {
        $urlparam=array_merge($urlparam,array("idform"=>$idform));
    }
    if (isset($datamodel)) {
        $urlparam=array_merge($urlparam,array("datamodel"=>$datamodel));
    }
    $this->renderPartial("_ff",$urlparam);
}