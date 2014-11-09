<h3>Пункти меню</h3>

<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати пункти меню',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genMenuItems/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>

<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-menu-items-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	//'itemsCssClass'=>'table-striped',
	'columns'=>array(
		array(
		'name'=>'id',
		'htmlOptions'=>array('width'=>'30px'),),
		array(
		'name'=>'content',
		'htmlOptions'=>array('width'=>'400px'),),
		'paderntid',
		'url',
		'ref',
		'visability',
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
