<?php
$this->breadcrumbs=array(
    "Головна"=>"/",
    $this->module->label => "/".$this->module->id,
    $this->label => "/".$this->module->id."/".$this->id,
);
?>
<ul>
    <li><a href="<?= $this->createUrl('formgen/index') ?>">Генератор свободных форм</a></li>
    <li><a href="<?= $this->createUrl('storage/index') ?>">Управление хранилищами</a></li>
    <li><a href="<?= $this->createUrl('formview/index') ?>">Тестирование документов на отчетных формах</a></li>
</ul>

