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
                'id', 
                'name', 
                array( 'class'=>'CButtonColumn', ), 
            ), 
     )
);