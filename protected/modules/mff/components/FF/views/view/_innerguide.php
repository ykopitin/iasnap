<?php

// ИД подгруженого справочника
try {
    echo $form->hiddenField($modelff, $data->name);
    // Генерируем класс для справочника
    $classname_guide = "FFModel_" . $data->name;
    eval("class $classname_guide extends FFModel {}");
    $vFFModel = new $classname_guide;
    // Подгружаем елемент если он уже есть
    if ($modelff->hasAttribute($data->name) && $modelff->getAttribute($data->name) != null) {
        $id_vFFModel = $modelff->getAttribute($data->name);
        $vFFModel->registry = 1;
        $vFFModel = $vFFModel->findByPk($id_vFFModel);
        $vFFModel->refresh();
    }
    // Создаем новый элемент если документ новый
    else if ($modelff->hasAttribute($data->name)) {
        $registrylist = array();
        foreach ($data->typeItem->storageItem->registryItems as $registryItem) {
            $registrylist = array_merge($registrylist, array($registryItem->id));
        }
        $vFFModel->registry = FFModel::commonParent($registrylist);
        $vFFModel->refreshMetaData();
    }
    $vFFModel->storage = $data->typeItem->storageItem->id;
    //echo $form->hiddenField($vFFModel,"id");
    
    $criteria = new CDbCriteria();
    $criteria->params[":formid"] = $vFFModel->registry;
    $criteria->addCondition("`formid` = :formid");
    $criteria->addCondition("`order` > 0");
    $criteria->order = "`order`";
    $dataProvider = new CActiveDataProvider("FFField", array(
        'criteria' => $criteria,
        'pagination' => array(
            'pageSize' => 30,
        )
            )
    );
    
    $this->widget("zii.widgets.CListView", array(
        'dataProvider' => $dataProvider,
        'pager' => true,
        'itemView' => 'ff_field',
        'summaryText' => '',
        'emptyText' => '',
//        'itemsTagName' => 'tbody',
//        'tagName' => 'table',
        'viewData' => array(
            "form" => $form,
            "modelff" => $vFFModel,
            "scenario" => $scenario,
            "htmlOptions" => $htmlOptions),
        'template' => '{items}',
        'htmlOptions' =>$htmlOptions,
            )
    );
    if ($scenario != "view") {
        $criteria2 = new CDbCriteria();
        $criteria2->with=array("typeItem");
        $criteria2->params[":formid"] = $vFFModel->registry;
        $criteria2->addCondition("`formid` = :formid");
        $criteria2->addCondition("`order` = 0");
        $criteria2->addCondition("`systemtype` is not null");
        $dataProvider2 = new CActiveDataProvider("FFField", array(
            'criteria' => $criteria2,
            'pagination' => array('pageSize' => 3000,)
                )
        );

        $this->widget("zii.widgets.CListView", array(
            'dataProvider' => $dataProvider2,
            'itemView' => "view/_hidden",
            'summaryText' => '',
            'emptyText' => '',
            'viewData' => array(
                "form" => $form,
                "modelff" => $vFFModel,
            ),
            'template' => '{items}',
                )
        );
    }
} catch (Exception $e) {
    echo "<span class='error' style='color:red'>" . $e->getMessage() . "</span>";
}