<?php
$modelstorage=new FFStorage;
CActiveForm::validate($modelstorage);
$this->beginWidget("zii.widgets.jui.CJuiDialog",        
        array( 
            "id"=>"dialogappendstorage",
            'options' => 
            array(
                'title' => 'Добавление хранилища',
                'modal' => true,
                'resizable'=> true,
                'autoOpen'=>false,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','type' => 'submit','click'=>'js:function(){formappendstorage.submit();}'), 
                    array('text'=>'Отменить','click'=> 'js:function(){$(this).dialog("close");}'),
                )
            ),
         )
);
$form=$this->beginWidget("CActiveForm", array(
    'id'=>'formappendstorage',
    'enableAjaxValidation' => true,
    'action'=>$this->createUrl($this->id.'/insert'),
    'clientOptions' => array(
        'validateOnChange'=>true,           
        ),
    )
);
?>
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