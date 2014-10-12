<tr>
    <td><?= CHtml::label($data->description,"") ?></td>
    <td>
        <?php       
            if (!isset($data->typeItem->view) || ($data->typeItem->view==null) || ($data->typeItem->view=="")) {
               $this->renderPartial("view/_default",array("data"=>$data,"form"=>$form,"modelff"=>$modelff)) ;
            }
            else {
               $this->renderPartial("view/_".$data->typeItem->view,array("data"=>$data,"form"=>$form,"modelff"=>$modelff)) ;
            }
        ?>
    </td>
</tr>
