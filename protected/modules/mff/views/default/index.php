<?php
//$this->breadcrumbs=array(
//    "Головна"=>array("/"),
//    "Админка"=>array("/admin"),
//    $this->module->label => array("/".$this->module->id),
//);
?>
<ul>
    <li><a href="<?= $this->createUrl('formgen/index') ?>">Генератор вільних форм</a></li>
    <li><a href="<?= $this->createUrl('storage/index') ?>">Управління сховищами</a></li>
    <li><a href="<?= $this->createUrl('formview/index') ?>">Внесення документів до сховищи</a></li>
    <li><a href="<?= $this->createUrl('cabinet/index') ?>">Перегляд кабінетів</a></li>
    <!--<li><a href="< ?= $this->createUrl('default/testff') ?>">Пример одиночной СФ</a></li>-->
</ul>

