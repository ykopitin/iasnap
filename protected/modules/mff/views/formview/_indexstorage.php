<tr>
    <td><?= $data->id ?></td>
    <td><?php 
    $data->tableName();
    $data->refreshMetaData();
    $data->refresh();
    echo isset($data->name)?$data->name:"";
    
    ?></td>
    <td>
        <?php 
        echo CHtml::link("Удалить",$this->createUrl("delete",array("idform"=>$data->id,"idstorage"=>$idstorage)));
        ?>
    </td>    
</tr>
