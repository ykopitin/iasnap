<tr><td colspan="5">        
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
echo $formaddfield->hiddenField($data,"id");
echo $formaddfield->hiddenField($data,"formid");
?>
<table style="width: 100%">
<tr>
<?php
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
echo "<td style='vertical-align: top;'>". $formaddfield->textField($data,"order",array("size"=>5))."<br>".
        $formaddfield->error($data,"order")."</td>";
echo "<td style='vertical-align: top;'>". $formaddfield->textArea($data,"description")."</td>";
?>
    <td  style='vertical-align: top;'>
        <?php 
        if ($data->isProtected() == FALSE) {
            $del_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"Minus")),"Видалити",array("width"=>24,"height"=>24,"title"=>"Видалити"));
            echo CHtml::link($del_img,$this->createUrl($this->id."/fielddelete",array("idfield"=>$data->id)));         
        }
        $upd_img = CHtml::image($this->createUrl("default/getimage",array("image"=>"Pencil")),"Змінити",array("width"=>24,"height"=>24,"title"=>"Змінити"));
        echo CHtml::link($upd_img,"#fieldedit".$data->id,array("onclick"=>"javascript: fieldedit".$data->id.".submit();"));         
        ?>        
    </td>
</tr>
</table>
<?php
$this->endWidget("CActiveForm");
?>
</td></tr>