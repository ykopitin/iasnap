<?php
$filepathname=get_class($modelff).strtolower($data->name)."_fileedspath";
//$signimage=get_class($modelff).strtolower($data->name)."_signimage";
$signimage="";
$contextTagId=get_class($modelff).'_'.strtolower($data->name);
$filename=$modelff->getAttribute(strtolower($data->name)."_fileedsname");
echo $form->hiddenField($modelff,strtolower($data->name)); // Содержимое файла 
if ($scenario=="update" || $scenario=="insert") {       
    $crypt=Yii::app()->findModule("mff")->cryptfile;
    echo CHtml::textField($filepathname,'',  array_merge(array("readonly"=>"readonly"),$htmlOptions)); // Путь к файлу
    echo ' ';
    $imgclick="ff_loadFile('$filepathname','$contextTagId',$crypt,'$signimage',null);";
    $scanclick="ff_scanFile('jScan','$filepathname','$contextTagId',$crypt);";
    $this->widget(
            "zii.widgets.jui.CJuiButton",
            array(
                'buttonType'=>'button',
                'name'=>'btnAttach_'.$data->name,
                'caption'=>'Прикріпити',
                'onclick'=>new CJavaScriptExpression('function(){'.$imgclick.';}'),    
            )
        );
//    if ($modelff->getFieldType())
    $this->widget(
            "zii.widgets.jui.CJuiButton",
            array(
                'buttonType'=>'button',
                'name'=>'btnScan_'.$data->name,
                'caption'=>'Відсканувати',
                'onclick'=>new CJavaScriptExpression('function(){jScan.selectDevice(); '.$scanclick.';}'),    
            )
    );
//    echo " <img title='Прикріпити документ' alt='Переглянути' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Folder"))."' class='fileedsbutton' onclick=\"$imgclick\" />";   
}
if (($scenario=="update" || $scenario=="view") &&  ($modelff->getAttribute(strtolower($data->name))!=null)) {
    $linkclick="ff_saveFile('".$contextTagId."','$filename','$signimage')";
    $this->widget(
        "zii.widgets.jui.CJuiButton",
        array(
            'buttonType'=>'button',
            'name'=>'btnView_'.$data->name,
            'caption'=>'Переглянути',
            'onclick'=>new CJavaScriptExpression('function(){'.$linkclick.';}'),  
        )
    );

//    $linkid=get_class($modelff).strtolower($data->name)."_link";
//    echo CHtml::link($filename,"#$linkid",array("onclick"=>$linkclick,"id"=>$linkid),$htmlOptions);
}
$imgclick='ff_certInfo("'.$contextTagId.'","'.$signimage.'");';
    $this->widget(
        "zii.widgets.jui.CJuiButton",
        array(
            'buttonType'=>'button',
            'name'=>'btnCert_'.$data->name,
            'caption'=>'Сертифікат',
            'onclick'=>new CJavaScriptExpression('function(){'.$imgclick.';}'),
        )
    );
//echo " ";
//echo "<img title='Підпис не визначений' alt='Підпис не визначений' id='".$signimage."1' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Question_mark"))."' class='fileedsbutton'  onclick='$imgclick' />";
//echo "<img title='Підпис не вірний' alt='Підпис не вірний' id='".$signimage."2' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Banned_sign"))."' class='fileedsbutton' style='display:none;'  onclick='$imgclick' />";
//echo "<img title='Підпис вірний' alt='Підпис вірний' id='".$signimage."3' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Key"))."' class='fileedsbutton' style='display:none;' onclick='$imgclick' />";

