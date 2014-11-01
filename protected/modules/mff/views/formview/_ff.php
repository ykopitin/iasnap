<?php
$title="Новая запись";
if (isset($scenario) && $scenario=="update"){
    $title="Изменить запись";
}
if ($scenario!="view") $buttons=array(
            array('text'=>'Сохранить','click'=> ('js:function(){formff.submit();}'),"visibility"=>($scenario!="view")),
            array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
        );
else $buttons=array(
            array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
        );
$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 
            'id' => 'dialogffform',
            'options' => 
            array(
                'title' => $title,
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => $buttons,
            )
       )
);

$url=$this->createUrl('indexstorage',array("id"=>$idstorage));
Yii::app()->clientScript->registerScript(
        "dialogclose_dialogffform",
        '$("#dialogffform").dialog({close:function(){window.location="'.$url.'"}})'
        );

$urlparam=array("idregistry"=>$idregistry,"idstorage"=>$idstorage);
if(isset($scenario)) {
    $urlparam=array_merge($urlparam,array("scenario"=>$scenario));
}
if(isset($idform)) {
    $urlparam=array_merge($urlparam,array("idform"=>$idform));
    $modelff=FFModel::model()->findByPk($idform);
    $modelff->refresh();
} else {
    $modelff=new FFModel();
    $modelff->registry=$idregistry;
    $modelff->refreshMetaData();
    $modelff->storage=$idstorage;
}

CActiveForm::validate($modelff);
$form=$this->beginWidget("CActiveForm", array(
        'id'=>'formff',
        'enableAjaxValidation' => true,
        'action'=>$this->createUrl('save',$urlparam),
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
            'pageSize' => 300,
        ),
    )
);


echo $form->hiddenField($modelff,"id");
$this->widget("zii.widgets.CListView", array(
    'dataProvider'=>$dataProvider,
    'pager'=>true,
    'summaryText'=>'',
    'emptyText'=>'',
    'itemView'=>'_ff_field',
    'tagName'=>'table',
    'template'=>'{items}',
    'itemsTagName'=>'tbody',
    'viewData'=>array("form"=>$form,
        "modelff"=>$modelff,
        "scenario"=>$scenario,
        "htmlOptions"=>array("<name field>"=>array("style"=>"width:100%"))
        ),
    )
);

if ($scenario!="view") {
    $criteria2=new CDbCriteria();
        $criteria2->params[":formid"] = $idregistry;
        $criteria2->addCondition("`formid` = :formid");
        $criteria2->addCondition("`order` = 0");
        $criteria2->order="`order`";
        $criteria2->with=array("typeItem");
        $criteria2->addCondition("`systemtype` is not null");
                
    $dataProvider2=new CActiveDataProvider("FFField", array(
            'criteria' => $criteria2,
            'pagination' => array('pageSize' => 3000,)
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
$this->endWidget("zii.widgets.jui.CJuiDialog");

