<?php
$this->breadcrumbs=array(
    "Головна"=>array("/"),
    "Админка"=>array("/admin"),
    $this->module->label => array("/".$this->module->id),
    $this->label => array("/".$this->module->id."/".$this->id),
);
if ($this->action->id=="index") {
    $this->widget("zii.widgets.jui.CJuiButton",
            array(
                "caption"=>"Добавить",
                "name"=>"btnAppendStorage",
                'buttonType'=>'button',
                "onclick"=>new CJavaScriptExpression('function(){$("#dialogappendstorage").dialog("open");}'),
            )
     );
}

$criteria=new CDbCriteria;
//$criteria->compare('id',$model->id);
$criteria->compare('name',$model->name,true);
$criteria->compare('description',$model->description,true);
$dp=new CActiveDataProvider($model, 
                    array(
                        'criteria'=>$criteria,
                        'pagination' => array(
                            'pageSize' => 20,
                            )
                        )
                    );

$this->widget('zii.widgets.grid.CGridView', 
        array(
            'id'=>'storage-grid', 
            'dataProvider'=>$dp, 
            'filter'=>$model, 
            "enablePagination"=>TRUE,
            'columns'=>array( 
                array('name'=>'id',"headerHtmlOptions"=>array("style"=>"width:60px"),'filter'=>''), 
                array('name'=>"name",), 
                array('name'=>"description",), 
                array('class'=>'CButtonColumn', 
                    "header"=>"Действия",
                    'buttons'=>array(
                        'view'=>array(
                        'visible'=>'false',
                        ),
                    ), 
                ), 
            )
       )
);
if ($this->action->id=="index") {
    $this->renderPartial("_append");
} else if ($this->action->id=="update") {
    $this->renderPartial("_edit",array("modelstorage"=>$modelstorage));
}