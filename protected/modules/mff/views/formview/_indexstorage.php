<tr>
    <td><?= $data->id ?></td>
    <?php 
    $data->tableName();
    $data->refreshMetaData();  
    $data->refresh();
    foreach ($columnnames as $columnname) {
        
     ?>
    <td><?= ($data->hasAttribute($columnname)?$data->getAttribute($columnname):"") ?></td>
    <?php } ?>
    <td>
        <?php 
        echo CHtml::link("Удалить",$this->createUrl("delete",array("idform"=>$data->id,"idstorage"=>$idstorage))); 
        echo "&nbsp;";
        echo CHtml::link("Изменить",$this->createUrl("save",array(
            "idform"=>$data->id,
            "idstorage"=>$idstorage, 
            "idregistry"=>$idregistry,
            "scenario"=>"update")));
        echo "&nbsp;";
        echo CHtml::link("Просмотр",$this->createUrl("save",array(
            "idform"=>$data->id,
            "idstorage"=>$idstorage, 
            "idregistry"=>$idregistry,
            "scenario"=>"view")));
        ?>
    </td>    
</tr>
