<?php

echo "<tr><td>".CHtml::encode($data->id)."</td>";
echo "<td>".CHtml::encode($data->tablename)."</td>";
echo "<td>".CHtml::encode($data->description)."</td>";
echo "<td>";
    $chield_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_right.png","Потомки");
    $edit_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_edit.png","Изменить");
    $delete_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_delete.png","Удалить");
    $add_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_add.png","Добавить потомка");
    if (count($data->chieldItems)>0 && !$data->attaching) echo CHtml::link($chield_img,array($this->id."/index","parentid"=>$data->id));
    if (!$data->isProtected()) {
        echo CHtml::link($edit_img,array($this->id."/edit","id"=>$data->id,"parentid"=>isset($data->parent)?$data->parent:NULL));
        if (count($data->chieldItems)==0) echo CHtml::link($delete_img,array($this->id."/delete","id"=>$data->id,"parentid"=>isset($data->parent)?$data->parent:NULL));
    }
    if (!$data->attaching) echo CHtml::link($add_img,array($this->id."/new","parentid"=>$data->id));
echo "</td></tr>";


