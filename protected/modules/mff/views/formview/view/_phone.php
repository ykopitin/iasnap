<?php
$this->widget('system.web.widgets.CMaskedTextField',array(
    'name'=>$data->name,
    'attribute'=>$data->name,
    'model'=>$modelff,
    'mask'=>'+99 (999) 999-99-99',
    'htmlOptions'=>array(
        'style'=>'height:20px;'
    ),
));