<?php
if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)),"") ;
else echo $form->textArea($modelff,$data->name,array("style"=>"width:100%")) ?>