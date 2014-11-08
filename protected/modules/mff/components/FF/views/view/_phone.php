<?php
if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)),"",$htmlOptions) ;
else {
    $this->widget('CMaskedTextField',array(
        'name'=>$data->name,
        'attribute'=>$data->name,
        'model'=>$modelff,
        'mask'=>'+99 (999) 999-99-99',
        'placeholder' => '_',
        'htmlOptions'=>$htmlOptions,
    ));
}