<BR>
<h3>Відомості про населені пункти</h3>

<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати населений пункт',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genLocations/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>

<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-locations-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		'type',
		'name',
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
