<?php
if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)), "", $htmlOptions) ;
else
$this->widget('system.web.widgets.CMaskedTextField',array(
    'name'=>$data->name,
    'attribute'=>$data->name,
    'model'=>$modelff,
    'mask'=>'9999-99-99 99:99:99',
    'htmlOptions'=>$htmlOptions,
));
?>