<BR>
<h3>Відомості про послуги</h3>
<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати нову послугу',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genServices/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>


<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-services-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
	//'id',
	array(
          'header' => '№ з/п',
		  'name' => 'idi',
          'value' => '$data->id',
		  'htmlOptions'=>array('width'=>'30px'),
      ),
	array(
	'name'=>'name',
	'htmlOptions'=>array('width'=>'400px'),
	),
	array(
          'header' => 'Місце подання',
		  'name' => 'author_search',
          'value' => '$data->subjnap->name',
		  'htmlOptions'=>array('width'=>'200px'),
	 ),
	array(
          'header' => 'Суб\'єкт надання',
		  'name' => 'author_search1',
          'value' => '$data->subjnapw->name',
		  'htmlOptions'=>array('width'=>'200px'),
      ),
	  array(
          'header' => 'Надання в електронному вигляді',
		  'name' => 'is_online',
          'value' => '$data->is_online',
		  'htmlOptions'=>array('width'=>'30px'),
      ),
	  //'is_online',

	
		
		array(
			'class'=>'CButtonColumn',
			'template'=>'{view}{update}{delete}',
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
				  'view' => array
                  (
                   'label'=>'Відобразити',
				   'url'=>'Yii::app()->createUrl("admin/genServices/index/id/$data->id")',
                  ),
				  
             ),
		),
	),
	//'sort'=>array('attributes'=>array('name')),
)); ?>
