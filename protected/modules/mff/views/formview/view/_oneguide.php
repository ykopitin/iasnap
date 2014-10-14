<div class="oneguide">
<?php $this->beginWidget('zii.widgets.CPortlet',array("title"=>$data->description));
    $v_FFModel=new fieldlist_FFModel;
    $v_FFModel->registry=1;
    $v_FFModel->refreshMetaData();
    if ($modelff->hasAttribute($data->name)&& $modelff->getAttribute($data->name)!=null) {
        $v_FFModel->findByPk($modelff->getAttribute($data->name));
        $v_FFModel->tableName();
        $v_FFModel->refreshMetaData();
        $v_FFModel->refresh();
        /// Отобразить выбраный элемент. Продолжение ниже из-за наличия общего кода
    }
    /// показать поисковую форму 
    $v_FFModel->storage=$data->typeItem->storageItem->id;
    $registrylist=array();
    foreach ($data->typeItem->storageItem->registryItems as $registryItem) {
        $registrylist= array_merge($registrylist,array($registryItem->id));
    }
    $v_FFModel->registry=FFModel::commonParent($registrylist);   
    $v_FFModel->refreshMetaData();
    // Добавить сортировку
    $columns=array();
    $criteriacolumn=new CDbCriteria();
    $criteriacolumn->addCondition("formid=".$v_FFModel->registry);
    $criteriacolumn->order="`order`";
    foreach (FFField::model()->findAll($criteriacolumn) as $column) {
        if ($column->order>0) {
            $columns=array_merge($columns , array(array("name"=>$column->name,"header"=>$column->description)));
        }
    }   
    $columns=array_merge($columns , array(array('class'=>'CButtonColumn',"header"=>"Действия")));
     /// Отобразить выбраный элемент
    if ($modelff->hasAttribute($data->name) &&  $modelff->getAttribute($data->name)!=null ) {
        $formview=$this->beginWidget("CActiveForm",  array(
            "id"=>"formview",
            ));
        $criteria=new CDbCriteria();
            $criteria->params[":formid"] = $v_FFModel->registry;
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
        echo $formview->hiddenField($v_FFModel,"id");
        
        $this->widget("zii.widgets.CListView", array(
            'dataProvider'=>$dataProvider,
            'pager'=>true,
            'itemView'=>'_ff_field',
            'itemsTagName'=>'tbody',
            'viewData'=>array(
                "form"=>$formview,
                "modelff"=>$v_FFModel,
                "htmlOptions"=>array("<name field>"=>array("style"=>"width:100%"))),
            'tagName'=>'table',
            'template'=>'{items}',
            )
        );
        
        $this->endWidget("CActiveForm");
    }
    
    $formselect=$this->beginWidget("CActiveForm",  array(
            "id"=>"formselect"
            ));
    
    $this->widget('zii.widgets.grid.CGridView', 
        array('id'=>'storage-grid', 
            'dataProvider'=>$v_FFModel->search(), 
            'filter'=>$v_FFModel, 
            "enablePagination"=>TRUE,    
            "summaryText"=>"Пошук:",
//            "htmlOptions"=>array("style"=>"display:none;"),
            'columns'=>$columns,
       )
    );
    $this->endWidget("CActiveForm");
    $this->widget("zii.widgets.jui.CJuiButton",array(
        'buttonType'=>'button',
        'caption'=>'Добавить',
        'name'=>$data->name."ButtonAdd",
    ));
    $this->widget("zii.widgets.jui.CJuiButton",array(
        'buttonType'=>'button',
        'caption'=>'Очистить',
        'name'=>$data->name."ButtonClear",
    ));
    
$this->endWidget('zii.widgets.CPortlet'); 
?>
</div>