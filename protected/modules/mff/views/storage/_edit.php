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
        <td style="width:30%"><?= $form->labelEx($modelstorage,"description") ?></td>
        <td><?= $form->textArea($modelstorage,"description",array("style"=>"width:100%")) ?></td>
    <tr>
        <td colspan="2"><?= $form->error($modelstorage,"description") ?></td>
    </tr>
    <tr>
        <td style="width:30%"><?= $form->labelEx($modelstorage,"subtype") ?></td>
        <td><?= $form->dropDownList($modelstorage,"subtype",
                array("",
                    "Выпадающий список",
                    "Линейный список",
                    "Встраиваемый справочник",
                    "Переключатель",
                    "Список нескольких значений",
//                    "Список нескольких значений для внешних таблиц",
                    )
                ) 
        ?></td>
    <tr>
        <td colspan="2"><?= $form->error($modelstorage,"multiselect") ?></td>
    </tr>
    <tr>
        <td style="width:30%"><?= $form->labelEx($modelstorage,"fields") ?></td>
        <td><?= $form->textArea($modelstorage,"fields",array("style"=>"width:100%")) ?></td>
    <tr>
        <td colspan="2"><?= $form->error($modelstorage,"fields") ?></td>
    </tr>    
    <tr>
        <td colspan="2">Подключенные формы к хранилищу</td>
    </tr>
    <tr>
        <td colspan="2">
            <?php
            $listtable=new CActiveDataProvider("FFRegistry", 
                    array(
                        'pagination' => array(
                            'pageSize' => 200,
                            )
                        )
                    );
            $this->widget('zii.widgets.grid.CGridView', 
                array('id'=>'storage-registry-grid', 
                'dataProvider'=>$listtable, 
                //'filter'=>$listtable->model, 
                "enablePagination"=>true,
                'columns'=>array( 
                array(
                    'class'=>'CCheckBoxColumn', 
                    'selectableRows' => 2,
                    'value'=>'$data->id',
                    'checked'=>'(FFRegistryStorage::model()->exists("registry=".$data->id." and storage='.$modelstorage->id.'")==1)',
                ), 
                array('name'=>"tablename"),                 
                array('name'=>"description"),                 
            )
       )
);
echo FFRegistryStorage::model()->exists("registry=1 and storage=18");
            ?>
        </td>
    </tr>
</table>
<?php
$this->endWidget("CActiveForm"); 
$this->endWidget("zii.widgets.jui.CJuiDialog");