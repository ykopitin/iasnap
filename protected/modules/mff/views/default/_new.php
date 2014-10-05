<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$formregistry = FFRegistry::model()->findByPk($parentid);
$target_save = 'window.location='."'".$this->createUrl('default/index')."'";
$target_close = 'window.location='."'".$this->createUrl('default/index',array("parentid"=>$parentid))."'";
$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 'options' => 
            array(
                'title' => 'Новая форма. Родительская форма:'.$formregistry->tablename,
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','click'=> ('js:function(){'.$target_save.';}')),
                    array('text'=>'Отменить','click'=> ('js:function(){'.$target_close.';}')),
    )
            )
        )
);

$form=$this->beginWidget("CActiveForm");
?>
<table>
    <tr>
<?php
echo "<td style='width:120px'>".$form->labelEx($formregistry,"tablename")."</td>";
echo "<td colspan=3>".$form->textField($formregistry, "tablename",array("readonly"=>"readonly","style"=>"width:100%"))."</td>";
?>
   </tr><tr>
<?php
echo "<td>".$form->labelEx($formregistry,"description")."</td>";
echo "<td colspan=3>".$form->textArea($formregistry,"description",array("style"=>"width:100%"))."</td>";
?>
   </tr><tr><td colspan=4>
<?php
$criteria2=new CDbCriteria();
$criteria2->compare("formid", isset($id)?$id:null);
$criteria2->order = '`order`, `id`';
$dataProvider2=new CActiveDataProvider("FFField", array(
        'criteria' => $criteria2,
        'pagination' => array(
            'pageSize' => 20,
        )
    )
        ); 
$headlabel = $dataProvider2->model->attributeLabels();

$this->widget("zii.widgets.ClistView", array(
    'dataProvider'=>$dataProvider2,
    'itemView'=>'_editfield',
    'tagName'=>'table',
    'itemsTagName'=>'tr',
    'template'=>'<caption>{summary}</caption><thead><th>'.$headlabel["name"].
        '</th><th>'.$headlabel["type"].'</th><th>'.$headlabel["order"].'</th><th>'.
        $headlabel["description"].'</th><th>Действия</th></thead><tbody>{items}</tbody>',
    )
);
//название таблицы - только просмотр
//описание таблицы
//поля(много)
//  имя поля
//  тип
//  описание
// кнопки отмены, сохранения
?>
</td></tr></table>
<?php 
$this->endWidget();
$this->widget("zii.widgets.jui.CJuiButton", array (
    "caption"=>"Добавить поле",
    "name"=>"addfield",
));
$this->endWidget("zii.widgets.jui.CJuiDialog");
