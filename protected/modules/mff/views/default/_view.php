<?php

echo "<td>".CHtml::encode($data->id)."</td>";
echo "<td>".CHtml::encode($data->parent)."</td>";
echo "<td>".CHtml::encode($data->tablename)."</td>";
echo "<td>".CHtml::encode($data->description)."</td>";
echo "<td>".CHtml::encode($data->protected)."</td>";
echo "<td>";
    $chield_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_right.png","Потомки");
    $edit_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_edit.png","Изменить");
    $delete_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_delete.png","Удалить");
    echo CHtml::link($chield_img,array("default/index","parentid"=>$data->id));
    echo CHtml::link($edit_img,array("default/edit","id"=>$data->id,"parentid"=>isset($parentid)?$parentid:NULL));
    echo CHtml::link($delete_img);
echo "</td>";

?>
