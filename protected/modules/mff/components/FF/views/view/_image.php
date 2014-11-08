<?php 
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];

if ($scenario=="update" || $scenario=="insert") {
    echo $form->fileField($modelff,strtolower($data->name),$_htmlOptions);
}
if (($scenario=="update" || $scenario=="view") && ($modelff->getAttribute(strtolower($data->name))!=null)) {
    echo CHtml::image($this->createUrl("getimage",array("id"=>$modelff->id,"name"=>$data->name)),'',$_htmlOptions);
}
?>
