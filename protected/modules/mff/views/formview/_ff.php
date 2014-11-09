<?php
$title="Новый";
if (isset($scenario) && $scenario=="update"){
    $title="Видредагувати";
}
if (isset($scenario) && $scenario=="view"){
    $title="Перегляд";
}
if ($scenario!="view") $buttons=array(
            array('text'=>'Зберігти','click'=> ('js:function(){formff_form.submit();}'),"visibility"=>($scenario!="view")),
            array('text'=>'Відмінити','click'=> ('js:function(){$(this).dialog("close");}')),
        );
else $buttons=array(
            array('text'=>'Відмінити','click'=> ('js:function(){$(this).dialog("close");}')),
        );
$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 
            'id' => 'dialogffform',
            'options' => 
            array(
                'title' => $title,
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => $buttons,
            )
       )
);
$backurl=base64_decode($backurl);
Yii::app()->clientScript->registerScript(
        "dialogclose_dialogffform",
        '$("#dialogffform").dialog({close:function(){window.location="'.$backurl.'"}})'
        );

$widgetparams=array(
            "name"=>"formff",
            "idregistry"=>$idregistry,
            "idstorage"=>$idstorage,    
            "scenario"=>$scenario,
            "backurl"=>$backurl,
//            "cssOptions"=>"/css/mff/test.css",
            );
if (isset($idform)) $widgetparams=array_merge($widgetparams,array("idform"=>$idform));
//Yii::app()->clientScript->registerCoreScript("maskedinput");
$widget=$this->widget("mff.components.FF.FFWidget",$widgetparams,false);
//echo $widget;
$this->endWidget("zii.widgets.jui.CJuiDialog");

