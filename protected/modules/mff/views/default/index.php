<?php
//$this->breadcrumbs=array(
//    "Головна"=>array("/"),
//    "Админка"=>array("/admin"),
//    $this->module->label => array("/".$this->module->id),
//);
?>
<ul>
    <li><a href="<?= $this->createUrl('formgen/index') ?>">Генератор свободных форм</a></li>
    <li><a href="<?= $this->createUrl('storage/index') ?>">Управление хранилищами</a></li>
    <li><a href="<?= $this->createUrl('formview/index') ?>">Тестирование документов на отчетных формах</a></li>
    <li><a href="<?= $this->createUrl('cabinet/index') ?>">Тестирование кабинетов</a></li>
    <li><a href="<?= $this->createUrl('default/testff') ?>">Тестирование одиночной СФ</a></li>
</ul>

