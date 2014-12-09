<?php
Yii::app()->clientScript->registerScriptFile(
        Yii::app()->createUrl("/mff/default/getscript",array("script"=>"cabineteds")));

if (!isset($cabinetmodel)) {
    if (isset($addons)) {
        $_addons=base64_decode($addons);
        eval('$_addons='.$_addons.";");
        $cabinetid=$_addons["cabinetid"];
        if (isset($_addons["folderid"])) $folderid=$_addons["folderid"];
    }
    $cabinetmodel=FFModel::model()->findByPk($cabinetid);
    if (empty($cabinetmodel) || $cabinetmodel==NULL) {
        echo "Такий кабінет відсутній";
        return;
    }
}
$cabinetmodel->refresh();
if ($this instanceof CWidget) {
    $controller=$this->getOwner();
    $backurl=base64_encode(Yii::app()->createUrl("cabinet/index"));   
}
else {
    $controller=$this;
    $backurl=base64_encode(Yii::app()->createUrl("cabinet/cabinet",array("id"=>$cabinetmodel->id)));
}
if (empty($controller->action) || $controller->action->id!="save") {
    $this->widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden'));
}
echo "<br />";

if (empty($thisrender) || $thisrender==NULL) $thisrender=  base64_encode ("mff.views.cabinet.cabinet");
$cabineturl=$thisrender;
//echo "<b>".$cabinetmodel->name."</b><br />";
//echo "<i>".$cabinetmodel->comment."</i><br />";
$userId=Yii::app()->User->id;
if (is_numeric($userId)){
    $user=new FFModel();
    $user->registry=  FFModel::user;
    $user->refreshMetaData();
    $user=$user->findByPk($userId);
    if (empty($cabinetmodel) || $cabinetmodel==NULL) {
        echo "Такий користувач відсутній";
        return;
    }    
//    echo "<span>Доброго дня,".$user->getAttribute("fio")."!</span><br /><br />";
}

$folders=$cabinetmodel->getItems("folders");

if (!is_array($folders)) {
    echo "Помилка з відображенням папок, зверніться до адміністратору сайту";
    return;
}
$tabs=array();
$urldata=array();
if (isset($idregistry)) $urldata=array_merge($urldata,array("idregistry"=>$idregistry,));
if (isset($idstorage)) $urldata=array_merge($urldata,array("idstorage"=>$idstorage,));
if (isset($storagemodel)) $urldata=array_merge($urldata,array("storagemodel"=>$storagemodel,));
if (isset($scenario)) $urldata=array_merge($urldata,array("scenario"=>$scenario,));
if (isset($idform)) $urldata=array_merge($urldata,array("idform"=>$idform,));
if (!isset($folderid) || $folderid==NULL) {
    if (isset($_GET["folderid"])) 
        $folderid=$_GET["folderid"];
    else {
        $startfolder=$cabinetmodel->getItems("startfolder");
        if (empty($startfolder) || $startfolder==NULL) {
            $folderid=$folders[0]->id;
        } else {
            $folderid=$startfolder[0]->id;
        }
    }
}
Yii::import("mff.components.utils.cabinetHelper");
$ch=new cabinetHelper($userId);

foreach ($folders as $folder) {
    $documentIds=$ch->getDocumensFromFolder($folder->id);
    if ($folder->id==$folderid) {
        $tab=array("tab".$folder->id=>
                array(
                    'title'=>$folder->name." (<span class='countdocuments' id='counter".$folder->id."'>".count($documentIds)."</span>)",
                    "view"=>"mff.views.cabinet.folder",
                    "data"=>array_merge(
                            array(
                                "backurl"=>$backurl,
                                "folder"=>$folder,
                                "cabinet"=>$cabinetmodel,
                                "cabineturl"=>$cabineturl,
                                "documentIds"=>$documentIds),
                            $urldata
                     )
                )
        );
    } else {
        $tab=array("tab".$folder->id=>
                 array(
                     'title'=>$folder->name." (<span class='countdocuments' id='counter".$folder->id."'>".count($documentIds)."</span>)",
                     'url'=>  Yii::app()->createUrl($controller->route,array("id"=>$cabinetmodel->id,"folderid"=>$folder->id))       
                     )
        );
        
    }
    $tabs=array_merge($tabs,$tab);
}
$this->widget("CTabView", array('tabs'=>$tabs,"activeTab"=>"tab".$folderid,
    'cssFile'=>Yii::app()->baseUrl.'/css/cabinet.css',
    )
);
//$this->widget("booster.widgets.TbTabs", array('tabs'=>$tabs,"activeTab"=>"tab".$folderid,));

if ($controller->action->id=="save") {
    if (empty($scenario)) $scenario="insert";
    if (empty($addons)) $addons=base64_encode('array("cabinetid"=>'.$cabinetmodel->id.')');
    $urldata=array(
        "backurl"=>$backurl,
        "thisrender"=>$cabineturl,
        "addons"=>$addons);
    if (isset($idregistry)) $urldata=array_merge($urldata,array("idregistry"=>$idregistry,));
    if (isset($idstorage)) $urldata=array_merge($urldata,array("idstorage"=>$idstorage,));
    if (isset($scenario)) $urldata=array_merge($urldata,array("scenario"=>$scenario,));
    if (isset($idform)) $urldata=array_merge($urldata,array("idform"=>$idform,));
    $controller->renderPartial("mff.views.formview._ff",$urldata);
}
 