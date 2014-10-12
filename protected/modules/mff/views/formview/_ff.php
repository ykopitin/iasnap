<?php
$title="Новая запись";
if (isset($scenario) && $scenario=="update"){
    $title="Изменить запись";
}
$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 
            'id' => 'dialogffform',
            'options' => 
            array(
                'title' => $title,
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','click'=> ('js:function(){formff.submit();}')),
                    array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
                )
            )
       )
);
?>
<script type="text/javascript">
    $.ready($("#dialogffform").dialog({close:function(){window.location='<?= $this->createUrl('indexstorage',array("id"=>$idstorage)) ?>'}}));
</script>
<?php
$urlparam=array("idregistry"=>$idregistry,"idstorage"=>$idstorage);
if(isset($scenario)) {
    $urlparam=array_merge($urlparam,array("scenario"=>$scenario));
}
if(isset($datamodel)) {
    $urlparam=array_merge($urlparam,array("idform"=>$datamodel->id));
    $modelff=$datamodel;
} else {
    $modelff=new FFModel();
}
CActiveForm::validate($modelff);
$form=$this->beginWidget("CActiveForm", array(
        'id'=>'formff',
//        'enableAjaxValidation' => true,
        'action'=>$this->createUrl('save',$urlparam),
//        'clientOptions' => array(
//            'validateOnChange'=>true,           
//        ),
    )
);

$criteria=new CDbCriteria();
    $criteria->params[":formid"] = $idregistry;
    $criteria->addCondition("`formid` = :formid");
    $criteria->addCondition("`order` > 0");
    $criteria->order="`order`";
    
$dataProvider=new CActiveDataProvider("FFField", array(
        'criteria' => $criteria,
        'pagination' => array(
            'pageSize' => 300,
        ),
    )
);


$modelff->storage=$idstorage;
$modelff->registry=$idregistry;
$modelff->refreshMetaData();
echo $form->hiddenField($modelff,"id");
$this->widget("zii.widgets.CListView", array(
    'dataProvider'=>$dataProvider,
    'pager'=>true,
    'itemView'=>'_ff_field',
    'viewData'=>array("form"=>$form,
        "modelff"=>$modelff,
        "htmlOptions"=>array("<name field>"=>array("style"=>"width:100%"))),
    'tagName'=>'table',
    'template'=>'<tbody>{items}</tbody>',
    )
);

$criteria2=new CDbCriteria();
    $criteria2->params[":formid"] = $idregistry;
    $criteria2->addCondition("`formid` = :formid");
    $criteria2->addCondition("`order` = 0");
    $criteria2->order="`order`";
    
$dataProvider2=new CActiveDataProvider("FFField", array(
        'criteria' => $criteria2,
    )
);

$this->widget("zii.widgets.CListView", array(
    'dataProvider'=>$dataProvider2,
    'itemView'=>"view/_hidden",
    'viewData'=>array("form"=>$form,
        "modelff"=>$modelff,
        ),
    'template'=>'{items}',
    )
);


$this->endWidget("CActiveForm");
$this->endWidget("zii.widgets.jui.CJuiDialog");

