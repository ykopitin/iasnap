<BR>
<h3>Посилання на статті до категорій сайту</h3>

<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати посилання',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genOtherInfo/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>

<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-other-info-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		array(
		'name'=>'id',
		'htmlOptions'=>array('width'=>'30px'),
		),
		array(
		'name'=>'publicationDate',
		'htmlOptions'=>array('width'=>'60px'),
		),
		array(
		'name'=>'title',
		'htmlOptions'=>array('width'=>'250px'),
		),
		array(
		'name'=>'summary',
		'htmlOptions'=>array('width'=>'600px'),
		),
		//'text',
		//'img',
		array(
          'header' => 'Розділ',
		  'name' => 'kindOfPublication.content',
          'value' => '$data->kindOfPublication->content',
		  'filter'=> CHtml::activeTextField($model, 'k_publication'),
		  'htmlOptions'=>array('width'=>'200px'),
	 ),
		
		
		/*
		'kind_of_publication',
		*/
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
			 'htmlOptions'=>array('width'=>'80px'),
		),
	),
	
)); ?>
