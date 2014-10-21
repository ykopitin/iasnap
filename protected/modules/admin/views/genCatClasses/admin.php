<BR>
<h3>Зв'язок категорій з класами</h3>

<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати зв\'язок',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/genCatClasses/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>


<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-cat-classes-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		array(
          'header' => 'Клас',
		  'name' => 'author_search1',
          'value' => '$data->class->item_name',
      ),
		array(
          'header' => 'Категорія',
		  'name' => 'author_search',
          'value' => '$data->categorie->name',
      ),
		array(
			'class'=>'CButtonColumn',
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
                  ),
             ),
		),
	),
)); ?>
