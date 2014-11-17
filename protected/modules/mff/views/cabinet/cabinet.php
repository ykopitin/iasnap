<?php
if (!isset($cabinetmodel)) {
    if (isset($addons)) {
        $addons=base64_decode($addons);
        eval('$addons='.$addons.";");
        $cabinetid=$addons["cabinetid"];
    }
    $cabinetmodel=FFModel::model()->findByPk($cabinetid);
    if (empty($cabinetmodel) || $cabinetmodel==NULL) {
        echo "Такий кабінет відсутній";
        return;
    }
}
$cabinetmodel->refresh();
if (empty($cabineturl) && isset($thisrender)) $cabineturl=$thisrender;
else if (empty($cabineturl) && empty($thisrender)) $cabineturl=  base64_encode(Yii::app()->getRequest()->getUrl());
echo "<b>".$cabinetmodel->name."</b><br />";
echo "<i>".$cabinetmodel->comment."</i><br />";
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
if (!isset($folderid) || $folderid==NULL) $folderid=$folders[0]->id;
foreach ($folders as $folder) {
    $tab=array("tab".$folder->id=>
            array(
                'title'=>$folder->name." (<span class='countdocuments' id='counter".$folder->id."'>0</span>)",
                "view"=>"mff.views.cabinet.folder",
                "data"=>array_merge(
                        array(
                            "folder"=>$folder,
                            "cabinet"=>$cabinetmodel,
                            "cabineturl"=>$cabineturl),
                        $urldata
                     )
                )
        );
    $tabs=array_merge($tabs,$tab);
}
$this->widget("CTabView", array('tabs'=>$tabs,"activeTab"=>"tab".$folderid,
//    'cssFile'=>Yii::app()->baseUrl.'/css/jquery.yiitab.css',
    )
);
if ((isset($this->owner) && ($this->owner->action->id=="save")) || (isset($this->action) && ($this->action->id=="save"))) {
    $urldata=array(
        "backurl"=>base64_encode(Yii::app()->createUrl("/mff/cabinet/cabinet",array("id"=>$cabinetmodel->id))),
        "thisrender"=>$cabineturl,
        "addons"=>base64_encode('array("cabinetid"=>'.$cabinetmodel->id.')'));
    if (isset($idregistry)) $urldata=array_merge($urldata,array("idregistry"=>$idregistry,));
    if (isset($idstorage)) $urldata=array_merge($urldata,array("idstorage"=>$idstorage,));
    if (isset($scenario)) $urldata=array_merge($urldata,array("scenario"=>$scenario,));
    if (isset($idform)) $urldata=array_merge($urldata,array("idform"=>$idform,));
    $this->renderPartial("/formview/_ff",$urldata);
}
