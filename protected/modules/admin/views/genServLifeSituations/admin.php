<h3>Зв'язок послуг з життєвими ситуаціями</h3>

<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати зв\'язок',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genServLifeSituations/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>

<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-serv-life-situations-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		//'service_id',
		//'life_situation_id',
		array(
          'header' => 'Послуга',
		  'name' => 'service_n',
          'value' => '$data->service->name',
      ),
		array(
          'header' => 'Життєва ситуація',
		  'name' => 'situation',
          'value' => '$data->lifeSituation->name',
      ),
		array(
			'class'=>'CButtonColumn',
			'template'=>'{update}{delete}',
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
