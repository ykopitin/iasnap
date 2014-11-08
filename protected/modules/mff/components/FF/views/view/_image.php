<?php 
if ($scenario=="update" || $scenario=="insert") {
    echo $form->fileField($modelff,strtolower($data->name),$htmlOptions);
}
if (($scenario=="update" || $scenario=="view") && ($modelff->getAttribute(strtolower($data->name))!=null)) {
    echo CHtml::image($this->createUrl("getimage",array("id"=>$modelff->id,"name"=>$data->name)),'',$htmlOptions);
}
?>
