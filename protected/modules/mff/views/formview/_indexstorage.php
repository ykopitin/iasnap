<tr>
    <td><?= $data->id ?></td>
    <?php    
    
    foreach ($columnnames as $columnname) {
     ?>
    <td><?= ($data->hasAttribute($columnname)?$data->getAttribute($columnname):"") ?></td>
    <?php } ?>
    <td>
        <?php 
        echo CHtml::link("Удалить",
                $this->createUrl(
                        "delete",
                        array(
                            "idform"=>$data->id,
                            "backurl"=>  base64_encode($this->createUrl("indexstorage",array("id"=>$data->storage)))
                            )
                        )
                ); 
        echo "&nbsp;";
        $addons=NULL;
        if (isset($currentpage)) $addons=base64_encode(serialize(array("currentpage"=>$currentpage)));
        if ($attaching==0) {
        echo CHtml::link("Изменить",$this->createUrl("save",array(
            "idform"=>$data->id,
            "idstorage"=>$data->storage, 
            "idregistry"=>$data->registry,
            "scenario"=>"update",
            "thisrender"=>base64_encode("mff.views.formview.indexstorage"),
            "addons"=>$addons,  
            )));
        echo "&nbsp;";
        echo CHtml::link("Просмотр",$this->createUrl("save",array(
            "idform"=>$data->id,
            "idstorage"=>$data->storage, 
            "idregistry"=>$data->registry,
            "scenario"=>"view",
            "thisrender"=>base64_encode("mff.views.formview.indexstorage"),
            "addons"=>$addons,  
            )));
        }
        ?>
    </td>    
</tr>
