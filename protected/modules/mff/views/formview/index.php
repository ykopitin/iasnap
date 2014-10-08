<?php
$this->breadcrumbs=array(
    "Головна"=>array("/"),
    "Админка"=>array("/admin"),
    $this->module->label => array("/".$this->module->id),
    $this->label => array("/".$this->module->id."/".$this->id),
);

$dataProvider=new CActiveDataProvider("FFStorage", array(
        //'criteria' => $criteria,
        'pagination' => array(
            'pageSize' => 30,
        )
    )
);
?>
<div class="grid-view">
<?php
$this->widget("zii.widgets.CListView", array(
    'dataProvider'=>$dataProvider,
    'itemView'=>'_index',
    'tagName'=>'table',
    'template'=>'<caption>{summary}</caption><thead><th>ID</th><th>'.
    $dataProvider->model->attributeLabels()["name"].'</th><th>'.
    $dataProvider->model->attributeLabels()["description"].
    '</th></thead><tbody>{items}</tbody>',
    'htmlOptions' => array("class"=>"items")
    //'itemsTagName'=>'tr',
    //'separator'=>'</tr>',
    )
);


?>
</div>