<?php
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];
if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)),"",$_htmlOptions) ;
else {
    $this->widget('CMaskedTextField',array(
        'name'=>$data->name,
        'attribute'=>$data->name,
        'model'=>$modelff,
        'mask'=>'+99 (999) 999-99-99',
        'placeholder' => '_',
        'htmlOptions'=>$_htmlOptions,
    ));
}