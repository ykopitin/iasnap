
<?php
/* @var $this ServiceController */




//echo ;
        $this->widget('zii.widgets.jui.CJuiAccordion',array('id'=>'opys', 
        'panels'=>array(
        'Нормативно правові акти, що регламентують надання послуги'=>GenServices::model()->findByPk($_GET['param'])->regulations,
        'Порядок та спосіб подання документів, необхідних для отримання адміністративної послуги'=>GenServices::model()->findByPk($_GET['param'])->submission_proc,
        'Перелік підстав для відмови у наданні адміністративної послуги'=>GenServices::model()->findByPk($_GET['param'])->denail_grounds,
        'Способи отримання відповіді (результату)'=>GenServices::model()->findByPk($_GET['param'])->answer,
        'Результат надання послуги'=>GenServices::model()->findByPk($_GET['param'])->result,
    ),
    // additional javascript options for the accordion plugin
    'options'=>array(
    
	        'collapsible'=> true,
	      // 'animated'=>'bounceslide',
	        'autoHeight'=>false,
	      'active'=>false,
          
    ),
));





?>
