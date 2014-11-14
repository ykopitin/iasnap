<?php
if ($scenario=="view") {
    $date = $modelff->getAttribute(strtolower($data->name));
    $date=($date==NULL)?"Не визначено":$date;
    echo CHtml::label($date,"",$htmlOptions) ;
}
else
    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
        'name'=>$data->name,
        'attribute'=>$data->name,
        'model'=>$modelff,
        'language'=>Yii::app()->getLanguage(),
        'options'=>array(
            'showAnim'=>'fold',
            'dateFormat'=>'yy-mm-dd',
    //        'dateFormat'=>'dd.mm.yy',
        ),
        'htmlOptions'=>$htmlOptions,
    ));