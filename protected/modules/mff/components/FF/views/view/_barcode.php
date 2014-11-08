<?php
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];

echo CHtml::image(Yii::app()->createUrl("/mff/formview/barcode",array("id"=>$modelff->id))); ?>