<?php
$this->breadcrumbs=array(
    "Головна"=>array("/"),
    "Админка"=>array("/admin"),
    $this->module->label => array("/".$this->module->id),
    $this->label => array("/".$this->module->id."/".$this->id),
    );

    echo 'Пользователь: <pre>';
    var_dump(Yii::app()->user);
    echo '</pre>';