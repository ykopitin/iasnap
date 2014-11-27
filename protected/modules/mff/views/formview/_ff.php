<?php
if (isset($_GET["idregistry"])) $idregistry=$_GET["idregistry"];
if (isset($_GET["idstorage"])) $idstorage=$_GET["idstorage"];
if (isset($_GET["idform"])) $idform=$_GET["idform"];
if (isset($_GET["scenario"])) $scenario=$_GET["scenario"];

$title="Новый";
if (isset($scenario) && $scenario=="update"){
    $title="Відредагувати";
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
                'width'=>"1000px",
                'buttons' => $buttons,
            )
       )
);
Yii::app()->clientScript->registerScript(
        "dialogclose_dialogffform",
        '$("#dialogffform").dialog({close:function(){window.location="'.Yii::app()->createAbsoluteUrl(base64_decode($backurl)).'"}})'
        );
if (empty($addons)) $addons=NULL;
$widgetparams=array(
            "name"=>"formff",
            "idregistry"=>$idregistry,
            "idstorage"=>$idstorage,    
            "scenario"=>$scenario,
            "backurl"=>$backurl,
            "addons"=>$addons,
//            "cssOptions"=>"/css/mff/test.css",
            );
if (isset($idform)) $widgetparams=array_merge($widgetparams,array("idform"=>$idform));
//Yii::app()->clientScript->registerCoreScript("maskedinput");
$widget=$this->widget("mff.components.FF.FFWidget",$widgetparams,false);
//echo $widget;
$this->endWidget("zii.widgets.jui.CJuiDialog");

