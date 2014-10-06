<?php
CActiveForm::validate($modelregistry);
$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 
            'id' => 'dialognew',
            'options' => 
            array(
                'title' => 'Регистрация внешней таблицы',
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','click'=> ('js:function(){registrytable.submit();}')),
                    array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
                )
            )
       )
);
$form=$this->beginWidget("CActiveForm", array(
        'id'=>'registrytable',
        'enableAjaxValidation' => true,
        'action'=>$this->createUrl($this->id."/registry"),
        'clientOptions' => array(
            'validateOnChange'=>true,           
        ),
    )
);
?>
<script type="text/javascript">
    $.ready($("#dialognew").dialog({close:function(){window.location='<?= $this->createUrl($this->id.'/index',array("parentid"=>$parentid)) ?>'}}));
</script>

<div id="noteblock">
<b>Внимание: </b><i>Регистрация внешних таблиц возможна только в корне</i>
</div>
<table style="width: 100%">
    <tr>
        <td style="width: 20%">
<?php echo $form->labelEx($modelregistry,"tablename"); ?>
        </td>
        <td>
<?php
$listtables = array(""=>"") + CHtml::listData(FFListTables::model()->findAll(), "TABLE_NAME", "TABLE_NAME");
echo $form->dropDownList($modelregistry,"tablename", $listtables,array("style"=>"width: 100%")); ?>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <?php echo $form->error($modelregistry,"tablename"); ?>
        </td>
    </tr> 
     <tr>
        <td>
<?php echo $form->labelEx($modelregistry,"description"); ?>
        </td>
        <td>
<?php echo $form->textArea($modelregistry,"description", array("style"=>"width: 100%")); ?>
        </td>
    </tr>
    <tr>
        <td>
<?php echo $form->labelEx($modelregistry,"view"); ?>
        </td>
        <td>
<?php echo $form->textField($modelregistry,"view", array("style"=>"width: 100%")); ?>
        </td>
    </tr>    
    <tr>
        <td colspan="2">
            <?php echo $form->error($modelregistry,"view"); ?>
        </td>
    </tr> 
</table>
<?php 
$this->endWidget("CActiveForm");
$this->endWidget("zii.widgets.jui.CJuiDialog");