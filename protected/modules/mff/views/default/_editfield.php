<tr>
<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$readonly=array();
if ($data->isProtected()) $readonly=array("readonly"=>"readonly");
echo "<td style='vertical-align: top;'>". CHtml::textField("name", $data->name,array_merge(array("size"=>16),$readonly))."</td>";
if ($data->isProtected()) {
    echo "<td style='vertical-align: top;'>". CHtml::textField("type", $data->typeItem->typename,array_merge(array("size"=>16),$readonly))."</td>";
} else {
    $listdata=  CHtml::listData(FFTypes::model()->findAll(), "id", "typename");
    echo "<td style='vertical-align: top;'>". CHtml::dropDownList("type", $data->type, $listdata)."</td>";
}
echo "<td style='vertical-align: top;'>". CHtml::textField("order", $data->order,array_merge(array("size"=>5),$readonly))."</td>";
echo "<td style='vertical-align: top;'>". CHtml::textArea("description", $data->description,$readonly)."</td>";
?>
    <td  style='vertical-align: top;'>
        <?php 
        if (!$data->isProtected($this)) {
            $del_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_delete.png","Удалить",array("width"=>24,"height"=>24));
            echo CHtml::link($del_img,$this->createUrl("default/fielddelete",array("idfield"=>$data->id)));         
        }
        ?>        
    </td>
</tr>