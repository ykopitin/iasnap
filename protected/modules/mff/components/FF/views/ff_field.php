<div id="<?=$this->name?>_field_<?=$data->name?>">
    <div id="<?=$this->name?>_fieldlabel_<?=$data->name?>"><?= CHtml::label($data->description,"") ?></div>
    <div id="<?=$this->name?>_fieldvalue_<?=$data->name?>">
        <?php       
            if (!isset($data->typeItem->view) || ($data->typeItem->view==null) || ($data->typeItem->view=="")) {
               $this->render("view/_default",array("data"=>$data,"form"=>$form,"modelff"=>$modelff,"scenario"=>$scenario)) ;
            }
            else {
               if (empty($htmlOptions) || $htmlOptions==NULL) $htmlOptions=array(); 
               $this->render("view/_".$data->typeItem->view,
                       array(
                           "data"=>$data,
                           "form"=>$form,
                           "modelff"=>$modelff,
                           "scenario"=>$scenario, 
                           "htmlOptions"=>array_key_exists($data->name, $htmlOptions)?$htmlOptions[$data->name]:NULL)) ;
            }
        ?>
    </div> 
    <div id="<?=$this->name?>_fielderror_<?=$data->id?>"><?= CHtml::error($data,"description") ?></div>    
</div>
