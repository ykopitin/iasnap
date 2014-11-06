<?php 
if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)),"") ;
else echo $form->textField($modelff,  strtolower($data->name),array("style"=>"width:100%"));
?>