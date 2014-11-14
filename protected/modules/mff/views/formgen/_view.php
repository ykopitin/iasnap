<?php

echo "<tr><td>".CHtml::encode($data->id)."</td>";
echo "<td>".CHtml::encode($data->tablename)."</td>";
echo "<td>".CHtml::encode($data->description)."</td>";
echo "<td>";
    $chield_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"Arrow_down")),"Нащадки",array("style"=>"width:24px"));
    $edit_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"Pencil")),"Змінити",array("style"=>"width:24px"));
    $delete_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"Minus")),"Видалити",array("style"=>"width:24px"));
    $add_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"Plus")),"Додати нащатка",array("style"=>"width:24px"));
    if (count($data->chieldItems)>0 && !($data->attaching===1)) echo CHtml::link($chield_img,array($this->id."/index","parentid"=>$data->id));
    if ($data->isProtected()==FALSE) {
        echo CHtml::link($edit_img,array($this->id."/edit","id"=>$data->id,"parentid"=>isset($data->parent)?$data->parent:NULL));
        if (count($data->chieldItems)==0) echo CHtml::link($delete_img,array($this->id."/delete","id"=>$data->id,"parentid"=>isset($data->parent)?$data->parent:NULL));
    }
    if (!($data->attaching==1)) echo CHtml::link($add_img,array($this->id."/new","parentid"=>$data->id));
echo "</td></tr>";


