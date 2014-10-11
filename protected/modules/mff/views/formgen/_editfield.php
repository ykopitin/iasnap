<?php
CActiveForm::validate($data);
$formaddfield=$this->beginWidget("CActiveForm", array(
        'id'=>'fieldedit'.$data->id,
        'enableAjaxValidation' => true,
        'action'=>$this->createUrl($this->id.'/fieldedit'),
        'clientOptions' => array(
            'validateOnChange'=>true,           
            ),
        )
    );
?>
<tr>
<?php
echo $formaddfield->hiddenField($data,"id");
echo $formaddfield->hiddenField($data,"formid");
$readonly=array();
if ($data->isProtected() == TRUE) $readonly=array("readonly"=>"readonly");
echo "<td style='vertical-align: top;'>". $formaddfield->textField($data,"name", array_merge(array("size"=>16),$readonly))."<br>".
        $formaddfield->error($data,"name")."</td>";
if ($data->isProtected() == TRUE) {
    echo "<td style='vertical-align: top;'>". $formaddfield->textField($data->typeItem,"typename",array_merge(array("size"=>16),$readonly))."</td>";
} else {
    $listdata=  CHtml::listData(FFTypes::model()->findAll(), "id", "typename");
    echo "<td style='vertical-align: top;'>". $formaddfield->dropDownList($data,"type", $listdata)."</td>";
}
echo "<td style='vertical-align: top;'>". $formaddfield->textField($data,"order",array_merge(array("size"=>5),$readonly))."<br>".
        $formaddfield->error($data,"order")."</td>";
echo "<td style='vertical-align: top;'>". $formaddfield->textArea($data,"description",$readonly)."</td>";
?>
    <td  style='vertical-align: top;'>
        <?php 
        if ($data->isProtected() == FALSE) {
            $del_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"data_delete")),"Удалить",array("width"=>24,"height"=>24));
            echo CHtml::link($del_img,$this->createUrl($this->id."/fielddelete",array("idfield"=>$data->id)));         
            $upd_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"data_edit")),"Изменить",array("width"=>24,"height"=>24));
            echo CHtml::link($upd_img,"javascript: fieldedit".$data->id.".submit();");         
        }
        ?>        
    </td>
</tr>
<?php
$this->endWidget("CActiveForm");