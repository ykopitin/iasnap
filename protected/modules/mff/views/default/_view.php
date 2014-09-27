<?php

echo "<tr><td>".CHtml::encode($data->id)."</td>";
echo "<td>".CHtml::encode($data->tablename)."</td>";
echo "<td>".CHtml::encode($data->description)."</td>";
echo "<td>";
    $chield_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_right.png","Потомки");
    $edit_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_edit.png","Изменить");
    $delete_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_delete.png","Удалить");
    if (count($data->chieldItems)>0) echo CHtml::link($chield_img,array("default/index","parentid"=>$data->id));
    if ($this->getModule()->enableprotected || !$data->protected) {
        echo CHtml::link($edit_img,array("default/edit","id"=>$data->id,"parentid"=>isset($parentid)?$parentid:NULL));
        if (count($data->chieldItems)==0) echo CHtml::link($delete_img);
    }
echo "</td></tr>";


