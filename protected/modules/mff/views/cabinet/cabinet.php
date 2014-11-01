<?php
echo "<b>".$cabinetmodel->name."</b><br />";
echo "<i>".$cabinetmodel->comment."</i><br />";
echo "<span>Пользователь:".Yii::app()->User->id."</span><br />";
$folders=$cabinetmodel->getItems("folders");
var_dump(Yii::app()->User);