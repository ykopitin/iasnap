<?php
/* @var $this GenLocationsController */
/* @var $model GenLocations */

$this->breadcrumbs=array(
	'Адміністративна панель'=>array('default/index'),
	'Управління довідниками'=>array('default/id4'),
	'Таблиця «Відомості про населені пункти»'=>array('index'),
	'Управління',
);

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
	$('#gen-locations-grid').yiiGridView('update', {
		data: $(this).serialize()
	});
	return false;
});
");
?>

<h1>Управляти даними Таблиця «Відомості про населені пункти»</h1>


<?php echo CHtml::link('Розширений пошук','#',array('class'=>'search-button')); ?>
<div class="search-form" style="display:none">
<?php $this->renderPartial('_search',array(
	'model'=>$model,
)); ?>
</div><!-- search-form -->

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
