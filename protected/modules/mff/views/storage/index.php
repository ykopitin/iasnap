<?php
$this->breadcrumbs=array(
    "Головна"=>"/",
    $this->module->label => "/".$this->module->id,
    $this->label => "/".$this->module->id."/".$this->id,
);
$this->widget('zii.widgets.grid.CGridView', 
        array('id'=>'storage-grid', 
            'dataProvider'=>$model->search(), 
            'filter'=>$model, 
            'columns'=>array( 
                array('name'=>'id',"headerHtmlOptions"=>array("style"=>"width:60px")), 
                array('name'=>"name"), 
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