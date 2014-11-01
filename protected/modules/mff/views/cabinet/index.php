<br />
<?php
$this->breadcrumbs=array(
    "Головна"=>array("/"),
    "Админка"=>array("/admin"),
    $this->module->label => array("/".$this->module->id),
    $this->label => array("/".$this->module->id."/".$this->id),
    );

$listcabinets=FFStorage::model()->findByPk($this->cabinet_storage);
echo CHtml::openTag("ul");
foreach ($listcabinets->records as $cabinet) {
    echo CHtml::openTag("li");
    $cabinet->refresh();
    echo CHtml::link($cabinet->name,$this->createUrl("cabinet",array("id"=>$cabinet->id)))." - ".$cabinet->getAttribute("comment"); 
    echo CHtml::closeTag("li");
}
echo CHtml::closeTag("ul");
