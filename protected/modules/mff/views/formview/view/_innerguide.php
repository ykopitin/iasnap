<?php 
// ИД подгруженого справочника
echo $form->hiddenField($modelff,$data->name);
// Генерируем класс для справочника
$classname_guide="FFModel_".$data->name;
eval("class $classname_guide extends FFModel {}");
$vFFModel=new $classname_guide;
//$vFFModel=new subguide_FFModel;
// Подгружаем елемент если он уже есть
if ($modelff->hasAttribute($data->name)&& $modelff->getAttribute($data->name)!=null) {
    $vFFModel->findByPk($modelff->getAttribute($data->name));
    $vFFModel->tableName();
    $vFFModel->refreshMetaData();
    $vFFModel->refresh();
} 
// Создаем новый элемент если документ новый
else if ($modelff->hasAttribute($data->name)) {
    $registrylist=array();
    foreach ($data->typeItem->storageItem->registryItems as $registryItem) {
        $registrylist= array_merge($registrylist,array($registryItem->id));
    }
    $vFFModel->registry=FFModel::commonParent($registrylist);   
    $vFFModel->tableName();
    $vFFModel->refreshMetaData();    
}
echo $form->hiddenField($vFFModel,"id");
//echo '<pre>';
//var_dump($vFFModel);
//echo '</pre>';
$criteria=new CDbCriteria();
    $criteria->params[":formid"] = $vFFModel->registry;
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
$this->widget("zii.widgets.CListView", array(
            'dataProvider'=>$dataProvider,
            'pager'=>true,
            'itemView'=>'_ff_field',
            'itemsTagName'=>'tbody',
            'tagName'=>'table',
            'viewData'=>array(
                "form"=>$form,
                "modelff"=>$vFFModel,
                "scenario"=>$scenario,
                "htmlOptions"=>array("<name field>"=>array("style"=>"width:100%"))),
            'template'=>'{items}',
            )
        );