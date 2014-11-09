<BR>
<h3>Внутрішні користувачі порталу</h3>
<?php
$this->widget('zii.widgets.jui.CJuiButton',array(
    'name'=>'cjui-link',
    'caption'=>'Додати користувача',
    'buttonType'=>'link',
    'url'=>Yii::app()->createUrl('/admin/CabUser/createint'),
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
	'dataProvider'=>$model->searchint(),
	'filter'=>$model,
	'columns'=>array(
//		'id',
		array(
			'header'=>'№ з/п',
			'name'=>'idi',
			'value'=>'$data->id',
//			'htmlOptions'=>array('width'=>'200px'),
		),
		'fio',
		'type_of_user',
//		'email',
//		'phone',
		'cab_state',
//		'user_roles_id',
		array(
			'header'=>'Роль користувача',
			'name'=>'user_rol',
			'value'=>'$data->cabUserRole->user_role',
			'htmlOptions'=>array('width'=>'200px'),
		),
//		'authorities_id',
		array(
			'header'=>'Місце надання послуг',
			'name'=>'author_search',
			'value'=>'$data->cabUserAuthorityId->name',
			'htmlOptions'=>array('width'=>'200px'),
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
