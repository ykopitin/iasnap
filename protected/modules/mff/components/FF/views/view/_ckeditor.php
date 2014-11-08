<?php
if (empty($htmlOptions) || !array_key_exists($data->name,$htmlOptions) || $htmlOptions[$data->name]==NULL) $_htmlOptions=array();
else $_htmlOptions=$htmlOptions[$data->name];

if ($scenario=="view") echo CHtml::label($modelff->getAttribute(strtolower($data->name)),"",$_htmlOptions) ;
else {
    $baseUrl = Yii::app()->baseUrl;
    $cs = Yii::app()->getClientScript();
    $cs->registerScriptFile($baseUrl.'/ckeditor/ckeditor.js');
    $namefield=get_class($modelff)."_".$data->name;
    echo $form->textArea($modelff,$data->name,$_htmlOptions) ?>
    <script type="text/javascript">
       var editor=CKEDITOR.instances.<?=$namefield?>;
       if (!editor) { 
           CKEDITOR.replace('<?= $namefield ?>');
       }       
    </script>
<?php } ?>