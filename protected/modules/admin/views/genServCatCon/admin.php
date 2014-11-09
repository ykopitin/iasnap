<h3>Управляти даними Таблиця «Звязок послуг з категоріями»</h3>



<?php $this->widget('zii.widgets.grid.CGridView', array(
	'id'=>'gen-serv-cat-con-grid',
	'dataProvider'=>$model->search(),
	'filter'=>$model,
	'columns'=>array(
		'id',
		'categorie_id',
		'service_id',
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
