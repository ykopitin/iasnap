<?php

$dialog=$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 
            'id' => 'dialognew',
            'options' => 
            array(
                'title' => 'Новая форма',
                'modal' => true,
                'resizable'=> true,
                'width'=>"65%",
                'buttons' => array(
                    array('text'=>'Сохранить','click'=> ('js:function(){formnew.submit();}')),
                    array('text'=>'Отменить','click'=> ('js:function(){$(this).dialog("close");}')),
                )
            )
       )
);
$form=$this->beginWidget("CActiveForm", array(
        'id'=>'formnew',
        'enableAjaxValidation' => true,
        'action'=>$this->createUrl($this->id.'/append',array("idregistry"=>$idregistry,"idstorage"=>$idstorage)),
        'clientOptions' => array(
            'validateOnChange'=>true,           
        ),
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
            'pageSize' => 30,
        )
    )
);
$modelff=new FFModel();
$modelff->storage=$idstorage;
$modelff->registry=$idregistry;
$modelff->refreshMetaData();
$this->widget("zii.widgets.CListView", array(
    'dataProvider'=>$dataProvider,
    'itemView'=>'_appendfieldff',
    'viewData'=>array("form"=>$form,"modelff"=>$modelff),
    'tagName'=>'table',
    'template'=>'<tbody>{items}</tbody>',
    )
);

$this->endWidget("CActiveForm");
$this->endWidget("zii.widgets.jui.CJuiDialog");
