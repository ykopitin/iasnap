<?php
if (!isset($cabinetmodel)) {
    $addons=base64_decode($addons);
    eval('$addons='.$addons.";");
    $cabinetid=$addons["cabinetid"];
    $cabinetmodel=FFModel::model()->findByPk($cabinetid);
    $cabinetmodel->refresh();
}
echo "<b>".$cabinetmodel->name."</b><br />";
echo "<i>".$cabinetmodel->comment."</i><br />";
echo "<span>Пользователь:".Yii::app()->User->id."</span><br /><br />";
$folders=$cabinetmodel->getItems("folders");
if (!is_array($folders)) {
    echo "Проблема с отображением папок в кабинете";
    return;
}
$tabs=array();
$urldata=array();
if (isset($idregistry)) $urldata=array_merge($urldata,array("idregistry"=>$idregistry,));
if (isset($idstorage)) $urldata=array_merge($urldata,array("idstorage"=>$idstorage,));
if (isset($storagemodel)) $urldata=array_merge($urldata,array("storagemodel"=>$storagemodel,));
if (isset($scenario)) $urldata=array_merge($urldata,array("scenario"=>$scenario,));
if (isset($idform)) $urldata=array_merge($urldata,array("idform"=>$idform,));
foreach ($folders as $folder) {
    $tab=array("tab".$folder->id=>
            array(
                'title'=>$folder->name." (<span class='countdocuments' id='counter".$folder->id."'>0</span>)",
                "view"=>"/cabinet/folder",
                "data"=>array_merge(
                        array(
                            "folder"=>$folder,
                            "cabinet"=>$cabinetmodel,),
                        $urldata
                     )
                )
        );
    $tabs=array_merge($tabs,$tab);
}
$this->widget("CTabView", array('tabs'=>$tabs,
//    'cssFile'=>Yii::app()->baseUrl.'/css/jquery.yiitab.css',
    )
);

