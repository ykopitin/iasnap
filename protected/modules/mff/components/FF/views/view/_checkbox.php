<div>
<?php
if ($scenario=="view") echo ($modelff->getAttribute($data->name)==1)?CHtml::label("Так","",$htmlOptions):CHtml::label("Ні","",$htmlOptions);
else 
    echo $form->checkBox($modelff,$data->name) ;
?>
</div>