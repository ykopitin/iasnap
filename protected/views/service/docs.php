<?php
/* @var $this ServiceController */




//echo ;
        $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
        'Перелік документів, необхідних для отримання адміністративної послуги'=>GenServices::model()->findByPk($_GET['param'])->docums,
           ),
    // additional javascript options for the accordion plugin
    'options'=>array(
	        'collapsible'=> true,
	     //   'animated'=>'bounceslide',
	        'autoHeight'=>false,
	        'active'=>false,
    ),
));






?>