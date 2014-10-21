<BR>
<h3>Управління новинами</h3>

<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати новину',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genNews/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>


<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-news-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		'publicationDate',
		'title',
		'summary',
				//'text',
		'img',
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
