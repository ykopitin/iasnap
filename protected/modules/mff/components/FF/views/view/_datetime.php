<?php
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];
if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)), "", $_htmlOptions) ;
else
$this->widget('system.web.widgets.CMaskedTextField',array(
    'name'=>$data->name,
    'attribute'=>$data->name,
    'model'=>$modelff,
    'mask'=>'9999-99-99 99:99:99',
    'htmlOptions'=>$_htmlOptions,
));
?>