<div id="<?=$this->name?>_field_<?=$data->id?>">
    <div id="<?=$this->name?>_fieldlabel_<?=$data->id?>"><?= CHtml::label($data->description,"") ?></div>
    <div id="<?=$this->name?>_fieldvalue_<?=$data->id?>">
        <?php       
            if (!isset($data->typeItem->view) || ($data->typeItem->view==null) || ($data->typeItem->view=="")) {
               $this->render("view/_default",array("data"=>$data,"form"=>$form,"modelff"=>$modelff,"scenario"=>$scenario)) ;
            }
            else {
               $this->render("view/_".$data->typeItem->view,array("data"=>$data,"form"=>$form,"modelff"=>$modelff,"scenario"=>$scenario)) ;
            }
        ?>
    </div> 
    <div id="<?=$this->name?>_fielderror_<?=$data->id?>"><?= CHtml::error($data,"description") ?></div>    
</div>
