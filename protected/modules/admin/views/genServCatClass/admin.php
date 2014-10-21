<BR>
<h3>Зв'язок послуг з категоріями та класами</h3>
<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати зв\'язок',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genServCatClass/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>

<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-serv-cat-class-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		array(
          'header' => 'Послуги',
		  'name' => 'service.name',
		  'value' => '$data->service->name',
		  'filter'=> CHtml::activeTextField($model, 'srv_name'),
		),
		array(
          'header' => 'Класи',
		  'name' => 'catClass.class.item_name',
		  'value' => '$data->catClass->class->item_name',
		  'filter'=> CHtml::activeTextField($model, 'class_name'),
		),
		array(
          'header' => 'Категорії',
		  'name' => 'catClass.categorie.name',
		  'value' => '$data->catClass->categorie->name',
		  'filter'=> CHtml::activeTextField($model, 'cat_name'),
		),
		
		
		array(
			'class'=>'CButtonColumn',
			'template'=>'{delete}{update}',
			'buttons'=>array
                 (
                   'delete' => array
                  (
                   'label'=>'Вилучити',
                  ),
				  'update' => array
                  (
                   'label'=>'Оновити',
                  ),
				  
             ),
		),
	),
)); ?>
