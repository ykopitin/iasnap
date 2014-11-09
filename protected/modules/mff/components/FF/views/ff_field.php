<div id="<?=$this->name?>_field_<?=$data->name?>">
    <div id="<?=$this->name?>_fieldlabel_<?=$data->name?>"><?= CHtml::label($data->description,"") ?></div>
    <div id="<?=$this->name?>_fieldvalue_<?=$data->name?>">
        <?php   
            $modelff->refresh();
            if (empty($htmlOptions) || $htmlOptions==NULL || !array_key_exists($data->name, $htmlOptions)) $_htmlOptions=array(); 
            else $_htmlOptions=$htmlOptions[$data->name];
            if (!isset($data->typeItem->view) || ($data->typeItem->view==null) || ($data->typeItem->view=="")) {
               $this->render("view/_default",
                       array(
                           "data"=>$data,
                           "form"=>$form,
                           "modelff"=>$modelff,
                           "scenario"=>$scenario,
                           "htmlOptions"=>$_htmlOptions)) ;
            }
            else {
               $this->render("view/_".$data->typeItem->view,
                       array(
                           "data"=>$data,
                           "form"=>$form,
                           "modelff"=>$modelff,
                           "scenario"=>$scenario, 
                           "htmlOptions"=>$_htmlOptions)) ;
            }
        ?>
    </div> 
    <div id="<?=$this->name?>_fielderror_<?=$data->name?>"><?= CHtml::error($data,"description") ?></div>    
</div>
