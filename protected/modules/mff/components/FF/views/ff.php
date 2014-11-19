<div id="<?= $this->name ?>">
<?php
$urlparam=array();
if($this->scenario!=null) {    
    $urlparam=array_merge($urlparam,array("scenario"=>$this->scenario));
}
if($this->addons!=null) {    
    $urlparam=array_merge($urlparam,array("addons"=>$this->addons));
}
if($this->idregistry!=null) {
    $urlparam=array_merge($urlparam,array("idregistry"=>$this->idregistry));
}
if($this->idstorage!=null) {
    $urlparam=array_merge($urlparam,array("idstorage"=>$this->idstorage));
}
if($this->idform!=null) {
    $urlparam=array_merge($urlparam,array("idform"=>$this->idform));
    $modelff=FFModel::model()->findByPk($this->idform);
    $modelff->refresh();
} else {
    $modelff=new FFModel();
    $modelff->registry=$this->idregistry;
    $modelff->refreshMetaData();
    $modelff->storage=$this->idstorage;
}
$urlparam=array_merge($urlparam,array("backurl"=>  base64_encode($this->backurl) ));
CActiveForm::validate($modelff);
$_addons=  base64_decode($this->addons);
//var_dump($_addons);
$form=$this->beginWidget("CActiveForm", array(
        'id'=>$this->name."_form",
        'enableAjaxValidation' => true,
        'action'=>Yii::app()->createUrl("/mff/formview/save",$urlparam),
        'clientOptions' => array(
            'validateOnChange'=>true,           
        ),
        'htmlOptions'=>array(
            'enctype'=>'multipart/form-data',
        ),
    )
);

$criteria=new CDbCriteria();
    $criteria->params[":formid"] = $modelff->registry;
    $criteria->addCondition("`formid` = :formid");
    $criteria->addCondition("`order` > 0");
    $criteria->order="`order`";
    
$dataProvider=new CActiveDataProvider("FFField", array(
        'criteria' => $criteria,
        'pagination' => array(
            'pageSize' => $this->fieldcount,
        ),
    )
);


echo $form->hiddenField($modelff,"id");
$this->widget("zii.widgets.CListView", array(
    'dataProvider'=>$dataProvider,
    'summaryText'=>'',
    'emptyText'=>'',
    'itemView'=>'ff_field',
    'template'=>'{items}',
    'enablePagination'=>TRUE,
    'viewData'=>array("form"=>$form,
        "modelff"=>$modelff,
        "scenario"=>$this->scenario,
        "htmlOptions"=>$this->fieldOptions,
        ),
    )
);

if ($scenario!="view") {
    $criteria2=new CDbCriteria();
        $criteria2->params[":formid"] = $this->idregistry;
        $criteria2->addCondition("`formid` = :formid");
        $criteria2->addCondition("`order` = 0");
        $criteria2->order="`order`";
        $criteria2->with=array("typeItem");
        $criteria2->addCondition("`systemtype` is not null");
                
    $dataProvider2=new CActiveDataProvider("FFField", array(
            'criteria' => $criteria2,
            'pagination' => array('pageSize' => 1000,)
            )   
    );

    $this->widget("zii.widgets.CListView", array(
        'dataProvider'=>$dataProvider2,
        'itemView'=>"view/_hidden",
        'summaryText'=>'',
        'emptyText'=>'',
        'viewData'=>array(
            "form"=>$form,
            "modelff"=>$modelff,
            ),
        'template'=>'{items}',
        )
    );
    
}

$this->endWidget("CActiveForm");
?>
</div>
