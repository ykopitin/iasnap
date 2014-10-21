<tr>
    <?php // if (isset($data->typeItem->systemtype) && $data->typeItem->systemtype!=null) {?>
    <td><?= CHtml::label($data->description,"") ?></td>
    <td>
        <?php       
            if (!isset($data->typeItem->view) || ($data->typeItem->view==null) || ($data->typeItem->view=="")) {
               $this->renderPartial("view/_default",array("data"=>$data,"form"=>$form,"modelff"=>$modelff,"scenario"=>$scenario)) ;
            }
            else {
               $this->renderPartial("view/_".$data->typeItem->view,array("data"=>$data,"form"=>$form,"modelff"=>$modelff,"scenario"=>$scenario)) ;
            }
        ?>
    </td>
    <?php // } else { ?>
    <!-- <td colspan="2" height="0"> -->
         <?php //  $this->renderPartial("view/_".$data->typeItem->view,array("data"=>$data,"form"=>$form,"modelff"=>$modelff,"scenario"=>$scenario)) ; ?>
        <!--</td>-->
    <?php //  } ?>
</tr>
