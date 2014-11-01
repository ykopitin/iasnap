<tr>
    <td><?= $data->id ?></td>
    <?php     
    foreach ($columnnames as $columnname) {
//        echo '<td>';
//        echo isset($data->attributes[$columnname])?$data->attributes[$columnname]:"";
//        var_dump($data->attributes);
//        echo '</td>';
     ?>
    <td><?= ($data->hasAttribute($columnname)?$data->getAttribute($columnname):"") ?></td>
    <?php } ?>
    <td>
        <?php 
        echo CHtml::link("Удалить",$this->createUrl("delete",array("idform"=>$data->id,"idstorage"=>$idstorage))); 
        echo "&nbsp;";
        if ($attaching==0) {
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
        }
        ?>
    </td>    
</tr>
