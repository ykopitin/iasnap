<?php
if ($scenario=="view") echo $modelff->getAttribute(strtolower($data->name)) ;
else
$this->widget('system.web.widgets.CMaskedTextField',array(
    'name'=>$data->name,
    'attribute'=>$data->name,
    'model'=>$modelff,
    'mask'=>'9999-99-99 99:99:99',
    'htmlOptions'=>array(
        'style'=>'height:20px;'
    ),
));
?>