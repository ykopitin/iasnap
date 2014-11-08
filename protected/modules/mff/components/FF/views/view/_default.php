<?php 
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];

if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)),"",$_htmlOptions) ;
else echo $form->textField($modelff,  strtolower($data->name),$_htmlOptions);
?>