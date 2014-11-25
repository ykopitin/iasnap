<?php
$filepathname=get_class($modelff).strtolower($data->name)."_fileedspath";
$signimage=get_class($modelff).strtolower($data->name)."_signimage";
$contextTagId=get_class($modelff).'_'.strtolower($data->name);
$filename=$modelff->getAttribute(strtolower($data->name)."_fileedsname");
echo $form->hiddenField($modelff,strtolower($data->name)); // Содержимое файла 
if ($scenario=="update" || $scenario=="insert") {       
    $crypt=Yii::app()->findModule("mff")->cryptfile;
    echo CHtml::textField($filepathname,'',  array_merge(array("readonly"=>"readonly"),$htmlOptions)); // Путь к файлу
    $imgclick="ff_loadFile('$filepathname','$contextTagId',$crypt,'$signimage');";
    echo " <img title='Прикріпити документ' alt='Переглянути' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Folder"))."' class='fileedsbutton' onclick=\"$imgclick\" />";   
}
if (($scenario=="update" || $scenario=="view") &&  ($modelff->getAttribute(strtolower($data->name))!=null)) {
    $linkid=get_class($modelff).strtolower($data->name)."_link";
    $linkclick="ff_saveFile('".$contextTagId."','$filename','$signimage')";
    echo CHtml::link($filename,"#$linkid",array("onclick"=>$linkclick,"id"=>$linkid),$htmlOptions);
}
$imgclick='ff_certInfo("'.$contextTagId.'","'.$signimage.'");';
echo " ";
echo "<img title='Підпис не визначений' alt='Підпис не визначений' id='".$signimage."1' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Question_mark"))."' class='fileedsbutton'  onclick='$imgclick' />";
echo "<img title='Підпис не вірний' alt='Підпис не вірний' id='".$signimage."2' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Banned_sign"))."' class='fileedsbutton' style='display:none;'  onclick='$imgclick' />";
echo "<img title='Підпис вірний' alt='Підпис вірний' id='".$signimage."3' src='".Yii::app()->createUrl("/mff/default/getimage",array("image"=>"Key"))."' class='fileedsbutton' style='display:none;' onclick='$imgclick' />";

