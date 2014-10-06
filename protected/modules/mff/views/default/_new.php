<?php
if (!isset($formregistry)) $formregistry = new FFRegistry();
$formregistry->parent = $parentid;
CActiveForm::validate($formregistry);
$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 
            'id' => 'dialognew',
            'options' => 
            array(
                'title' => 'Новая форма. Родительская форма: '.$formregistry->parentItem->tablename,
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','click'=> ('js:function(){formnew.submit();}')),
                    array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
                )
            )
       )
);
$form=$this->beginWidget("CActiveForm", array(
        'id'=>'formnew',
        'enableAjaxValidation' => true,
        'action'=>$this->createUrl($this->id.'/new',array("parentid"=>$parentid)),
        'clientOptions' => array(
            'validateOnChange'=>true,           
        ),
    )
);
echo $form->hiddenField($formregistry,"parent");
?>
<table>
    <tr>
<?php
echo "<td style='width:120px'>".$form->labelEx($formregistry,"tablename")."</td>";
echo "<td colspan=3>".$form->textField($formregistry, "tablename",array("style"=>"width:100%"))."</td>";
?>
   </tr>
   <tr>
       <td colspan="4">
       <?php
        echo $form->error($formregistry, "tablename");
       ?>
       </td>
   </tr>
   <tr>
<?php
echo "<td>".$form->labelEx($formregistry,"description")."</td>";
echo "<td colspan=3>".$form->textArea($formregistry,"description",array("style"=>"width:100%"))."</td>";
?>
   </tr>   
   <tr>
       <td colspan="4">
       <?php
        echo $form->error($formregistry, "description");
       ?>
       </td>
   </tr>
</table>
<?php 
$this->endWidget("CActiveForm");
$this->endWidget("zii.widgets.jui.CJuiDialog");
