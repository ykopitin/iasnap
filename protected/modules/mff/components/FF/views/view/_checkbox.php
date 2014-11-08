<div>
<?php
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];
if ($scenario=="view") echo ($modelff->getAttribute($data->name)==1)?CHtml::label("Так","",$_htmlOptions):CHtml::label("Ні","",$_htmlOptions);
else 
    echo $form->checkBox($modelff,$data->name) ;
?>
</div>