<?php
CActiveForm::validate($modelstorage);
$this->beginWidget("zii.widgets.jui.CJuiDialog",        
        array( 
            "id"=>"dialogeditstorage",
            'options' => 
            array(
                'title' => 'Изменение хранилища',
                'modal' => true,
                'resizable'=> true,
                'autoOpen'=>true,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','type' => 'submit','click'=>'js:function(){formeditstorage.submit();}'), 
                    array('text'=>'Отменить','click'=> 'js:function(){$(this).dialog("close");}'),
                )
            ),
         )
);
$form=$this->beginWidget("CActiveForm", array(
    'id'=>'formeditstorage',
    'enableAjaxValidation' => true,
    'action'=>$this->createUrl($this->id.'/update',array("id"=>$modelstorage->id)),
    'clientOptions' => array(
        'validateOnChange'=>true,           
        ),
    )
);
?>
<script type="text/javascript">
    $.ready($("#dialogeditstorage").dialog({close:function(){window.location='<?= $this->createUrl($this->id.'/index') ?>'}}));
</script>

<table>
    <tr>
        <td style="width:30%"><?= $form->labelEx($modelstorage,"name") ?></td>
        <td><?= $form->textField($modelstorage,"name",array("style"=>"width:100%")) ?></td>
    <tr>
        <td colspan="2"><?= $form->error($modelstorage,"name") ?></td>
    </tr>
    <tr>
        <td style="width:30%"><?= $form->labelEx($modelstorage,"comment") ?></td>
        <td><?= $form->textArea($modelstorage,"comment",array("style"=>"width:100%")) ?></td>
    <tr>
        <td colspan="2"><?= $form->error($modelstorage,"comment") ?></td>
    </tr>
</table>
<?php
$this->endWidget("CActiveForm"); 
$this->endWidget("zii.widgets.jui.CJuiDialog");