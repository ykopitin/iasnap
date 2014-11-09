<h3>Управляти даними Таблиця «Звязок послуг з класами»</h3>



<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-serv-con-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		'service_id',
		'class_id',
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
