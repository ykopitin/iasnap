<h3>Відомості про центри та суб'єкти</h3>

<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати суб\'єкта',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genAuthorities/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>

<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-authorities-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		array(
		'name'=>'id',
		'htmlOptions'=>array('width'=>'30px'),
		),
		'is_cnap',
		'type',
		'name',
		//'locations_id',
		array(
        	'header' => 'Населений пункт',
			'name'=>'locat',
	        'value'=>'$data->locations->name',
			//'filter'=> CHtml::activeTextField($model, 'locat'),
	    ),
		//'index',
		/*
		'street',
		'building',
		'office',
		'working_time',
		'phone',
		'fax',
		'email',
		'web',
		'transport',
		'gpscoordinates',
		'photo',
		*/
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
