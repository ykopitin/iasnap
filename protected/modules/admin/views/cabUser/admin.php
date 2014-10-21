<BR>
<h3>Зовнішні користувачі порталу</h3>
<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати користувача',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/CabUser/create'),
    'htmlOptions'=>array(
        'style'=>'color:#ffffff;background: #0064cd;'
    ),
    //'onclick'=>new CJavaScriptExpression('function(){alert("Enter User Name"); this.blur(); return false;}'),
    
));
?>
<?php
/* @var $this CabUserExternalController */
/* @var $model CabUserExternal */
/*
$this->menu=array(
	array('label'=>'Відобразити', 'url'=>array('index')),
	array('label'=>'Додати', 'url'=>array('create')),
);

Yii::app()->clientScript->registerScript('search', "
$('.search-button').click(function(){
	$('.search-form').toggle();
	return false;
});
$('.search-form form').submit(function(){
	$('#cab-user-external-grid').yiiGridView('update', {
		data: $(this).serialize()
	});
	return false;
});
");
*/
?>

<?php /* echo CHtml::link('Розширений пошук','#',array('class'=>'search-button')); */ ?>
<div class="search-form" style="display:none">
<?php $this->renderPartial('_search',array(
	'model'=>$model,
)); ?>
</div><!-- search-form -->

<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'cab-user-external-grid',
	'dataProvider'=>$model->searchext(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		'fio',
		'type_of_user',
		'email',
		'phone',
		'cab_state',
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
