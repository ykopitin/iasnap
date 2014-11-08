<?php
$title="Новая запись";
if (isset($scenario) && $scenario=="update"){
    $title="Изменить запись";
}
if ($scenario!="view") $buttons=array(
            array('text'=>'Сохранить','click'=> ('js:function(){formff_form.submit();}'),"visibility"=>($scenario!="view")),
            array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
        );
else $buttons=array(
            array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
        );
$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 
            'id' => 'dialogffform',
            'options' => 
            array(
                'title' => $title,
                'modal' => true,
                'resizable'=> true,
                'width'=>"75%",
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
            "CSSOptions"=>"/css/mff/test.css",
            );
if (isset($idform)) $widgetparams=array_merge($widgetparams,array("idform"=>$idform));
$widget=$this->widget("mff.components.FF.FFWidget",$widgetparams);

$this->endWidget("zii.widgets.jui.CJuiDialog");

