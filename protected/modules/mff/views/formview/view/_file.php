<?php 
if ($scenario=="update" || $scenario=="insert") {
    echo $form->fileField($modelff,strtolower($data->name));
}
if (($scenario=="update" || $scenario=="view") &&  ($modelff->hasAttribute(strtolower($data->name)) && ($modelff->getAttribute(strtolower($data->name))!=null))) {
    echo CHtml::link($modelff->getAttribute(strtolower($data->name)."_filename"),$this->createUrl("getfile",array("id"=>$modelff->id,"name"=>$data->name)));
}
?>