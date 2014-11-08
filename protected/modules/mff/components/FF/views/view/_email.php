<?php
if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)),"",$htmlOptions) ;
else echo $form->emailField($modelff,$data->name,$htmlOptions) ?>