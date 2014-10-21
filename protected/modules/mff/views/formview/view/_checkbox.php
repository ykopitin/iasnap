<div>
<?php
if ($scenario=="view") echo ($modelff->getAttribute($data->name)==1)?CHtml::label("Так",""):CHtml::label("Ні","");
else 
    echo $form->checkBox($modelff,$data->name) ;
?>
</div>