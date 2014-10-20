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
$this->widget("zii.widgets.CListView", array(
    'dataProvider'=>$dataProvider,
    'itemView'=>'_indexstorage',
    'viewData'=>array("idstorage"=>$storagemodel->id,"idregistry"=>$registrymodel->id),
    'tagName'=>'table',
    'template'=>'<caption>{summary}</caption><thead><th>ID</th><th>Name</th>'.
    '<th>Действия</th></thead><tbody>{items}</tbody>',
    )
);

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