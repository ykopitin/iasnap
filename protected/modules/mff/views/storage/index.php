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
$dp=new CActiveDataProvider("FFStorage", 
                    array(
                        'pagination' => array(
                            'pageSize' => 25,
                            )
                        )
                    );
$this->widget('zii.widgets.grid.CGridView', 
        array('id'=>'storage-grid', 
            'dataProvider'=>$dp, 
            //'filter'=>$model, 
            "enablePagination"=>TRUE,
            'columns'=>array( 
                array('name'=>'id',"headerHtmlOptions"=>array("style"=>"width:60px")), 
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