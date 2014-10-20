<?php 
if ($scenario=="update" || $scenario=="insert") {
    echo $form->fileField($modelff,strtolower($data->name));
}
if (($scenario=="update" || $scenario=="view") &&  ($modelff->hasAttribute(strtolower($data->name)) && ($modelff->getAttribute(strtolower($data->name))!=null))) {
    echo CHtml::image($this->createUrl("getimage",array("id"=>$modelff->id,"name"=>$data->name)),'',array("style"=>"width:70%"));
}
?>
