<?php
if (isset($_GET["idregistry"])) $idregistry=$_GET["idregistry"];
if (isset($_GET["idstorage"])) $idstorage=$_GET["idstorage"];
if (isset($_GET["idform"])) $idform=$_GET["idform"];
if (isset($_GET["scenario"])) $scenario=$_GET["scenario"];
if (isset($_GET["addons"])) $addons=$_GET["addons"];

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
if (isset($scenario) && ($scenario=="view" || $scenario=="update")) {
    $printurl=Yii::app()->createUrl("/mff/print/print",array("id"=>$idform,"profile"=>"opis"));
    $buttons=array_merge(
            array(
                array(
                'text'=>'Друк опису',
                'click'=> 'js:function(){window.open("'.$printurl.'","print1");}'),
                ),
            $buttons
            );
    $printurl=Yii::app()->createUrl("/mff/print/print",array("id"=>$idform,"profile"=>"prohod"));
    $buttons=array_merge(
            array(
                array(
                'text'=>'Друк листа проходження',
                'click'=> 'js:function(){window.open("'.$printurl.'","print2");}'),
                ),
            $buttons
            );
    // Список действий
    if (isset($addons)) {
        eval('$_addons='.base64_decode($addons).";");
        $userId=Yii::app()->user->id;
        if (isset($_addons) && isset($_addons["folderid"])) {
            $folderid=$_addons["folderid"];
            $doc=FFModel::model()->findByPk($idform);
            $doc->refresh();
            $actions=$doc->getActionsFromFolder($folderid,$userId);
            foreach ($actions as $action) {
                if ($scenario=="update") {
                    $click="activeaction.value=".$action->id.";formff_form.submit();";
                } else {
                    $cabinetid=$_addons["cabinetid"];
                    $urlaction=Yii::app()->createUrl("/mff/cabinet/doaction",
                    array(                    
                        "actionid"=>$action->id,
                        "documentid"=>$idform,                       
                        "userId"=>$userId,
                        "cabineturl"=>base64_encode(
                                Yii::app()->createUrl("/cabinet",
                                        array("id"=>$cabinetid,
                                            "folderid"=>$folderid)
                                        )
                                ),
                        )
                    );
                    $click='document.location="'.$urlaction.'";';
                }
                $buttons=array_merge(
                    array(
                        array(
                        'text'=>$action->name,
                        'click'=> 'js:function(){'.$click.';}'),
                        ),
                    $buttons
                );                 
            }
                       
        }
    }
}
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

