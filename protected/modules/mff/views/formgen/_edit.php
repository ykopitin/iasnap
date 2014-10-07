<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$formregistry = FFRegistry::model()->findByPk($id);
$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 'options' => 
            array(
                'title' => 'Изменить форму ID:'.$id,
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','click'=> 'js:function(){formedit.submit();}', 'visible'=>!$formregistry->isProtected($this)),
                    array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
                )
            ),
            'id' => 'frmedit',
        )
);

$form=$this->beginWidget("CActiveForm",array(
        'id'=>'formedit',
        'enableAjaxValidation' => true,
        'action'=>$this->createUrl($this->id.'/save')
    )
);
echo $form->hiddenField($formregistry,"id");
echo $form->hiddenField($formregistry,"parent");
?>
<script type="text/javascript">
    $.ready($("#frmedit").dialog({close:function(){window.location='<?= $this->createUrl($this->id.'/index',array("parentid"=>$parentid)) ?>'}}));
</script>
<table>
    <tr>
<?php
echo "<td style='width:120px'>".$form->labelEx($formregistry,"tablename")."</td>";
echo "<td colspan=3>".$form->textField($formregistry, "tablename",array("readonly"=>"readonly","style"=>"width:100%"))."</td>";
?>
   </tr><tr>
       <?php echo "<td colspan=4>".$form->error($formregistry, "tablename")."</td>"; ?>
   </tr><tr>
<?php
echo "<td>".$form->labelEx($formregistry,"description")."</td>";
echo "<td colspan=3>".$form->textArea($formregistry,"description",array("style"=>"width:100%"))."</td>";
?>
   </tr><tr>
        <?php echo "<td colspan=4>".$form->error($formregistry, "description")."</td>"; ?>
   </tr><tr>
<?php
echo "<td>".$form->labelEx($formregistry,"view")."</td>";
echo "<td colspan=3>".$form->textField($formregistry,"view",array("style"=>"width:100%"))."</td>";
?>
   </tr><tr>
        <?php echo "<td colspan=4>".$form->error($formregistry, "view")."</td>"; ?>
   </tr>
<?php if (!$formregistry->attaching) { ?>
<tr>
<?php
echo "<td>".$form->labelEx($formregistry,"copying")."</td>";
echo "<td colspan=3>".$form->checkBox($formregistry,"copying")."</td>";
?>
   </tr><tr>
        <?php echo "<td colspan=4>".$form->error($formregistry, "copying")."</td>"; ?>
   </tr>   
   <tr>
<td colspan=4>
<?php
    $criteria2=new CDbCriteria();
    $criteria2->compare("formid", isset($id)?$id:null);
    $criteria2->order = '`order`, `id`';
    $dataProvider2=new CActiveDataProvider("FFField", array(
            'criteria' => $criteria2,
            'pagination' => array(
                'pageSize' => 5,
            )
        )
            ); 
    $headlabel = $dataProvider2->model->attributeLabels();

    $this->widget("zii.widgets.ClistView", array(
        'dataProvider'=>$dataProvider2,
        'itemView'=>'_editfield',
        'tagName'=>'table',
        'itemsTagName'=>'tr',
        'enablePagination' => true,
        'template'=>'<caption>{summary}</caption>'.
            '<thead><th>'.$headlabel["name"].'</th><th>'.$headlabel["type"].
            '</th><th>'.$headlabel["order"].'</th><th>'.
            $headlabel["description"].'</th><th>Действия</th></thead>'.
            '<tfoot><tr><td colspan="5">{pager}</td></tr></tfoot>'.
            '<tbody>{items}</tbody>',
        )
    );
?>
</td></tr>
<?php } ?>
</table>
<?php  
if (!$formregistry->attaching && !$formregistry->isProtected()) {
        $this->widget("zii.widgets.jui.CJuiButton", array (
            "caption"=>"Добавить поле",
            "name"=>"addfield",
            "onclick"=>'js:function(){$("#frmaddfield").dialog("open");}',
        ));
}
$this->endWidget("CActiveForm");
$this->endWidget("zii.widgets.jui.CJuiDialog");
if (!$formregistry->attaching) $this->renderPartial("_addfield",array("formid"=>$id));
