<?php
/* @var $this ServiceController */

if (GenServices::model()->findByPk($_GET['param'])->have_expertise=='1'){

if (GenServices::model()->findByPk($_GET['param'])->is_payed_expertise=='1'){
     $this->widget('zii.widgets.jui.CJuiAccordion',array('id'=>'opys2', 
    'panels'=>array(
        'Необхідність у проведенні експертизи (обстеження) обєкта'=>GenServices::model()->findByPk($_GET['param'])->nes_expertise,
        'Платність експертизи (обстеження)'=>GenServices::model()->findByPk($_GET['param'])->payed_expertise,
        'Акти законодавства, на підставі яких стягується плата'=>GenServices::model()->findByPk($_GET['param'])->regul_expertise,
        'Розмір плати проведення експертизи (обстеження)'=>GenServices::model()->findByPk($_GET['param'])->rate_expertise,
        'Банківські реквізити для внесення плати щодо проведення експертизи (обстеження)'=>GenServices::model()->findByPk($_GET['param'])->bank_info_expertise,
        ),
    // additional javascript options for the accordion plugin
    'options'=>array(
	        'collapsible'=> true,
	      //  'animated'=>'bounceslide',
	        'autoHeight'=>false,
	      'active'=>false,
    ),
));   
    
}else{
    $this->widget('zii.widgets.jui.CJuiAccordion',array('id'=>'opys2', 
    'panels'=>array(
        'Необхідність у проведенні експертизи (обстеження) обєкта'=>GenServices::model()->findByPk($_GET['param'])->nes_expertise,
        'Платність експертизи (обстеження)'=>'Безоплатно',
        ),
    // additional javascript options for the accordion plugin
    'options'=>array(
	        'collapsible'=> true,
	      //  'animated'=>'bounceslide',
	        'autoHeight'=>false,
	      'active'=>false,
    ),
));
}

}
else {
     $this->widget('zii.widgets.jui.CJuiAccordion',array('id'=>'opys2', 
    'panels'=>array(
        'Необхідність у проведенні експертизи (обстеження) обєкта'=>'Експертиза не потрібна',
         ),
    // additional javascript options for the accordion plugin
    'options'=>array(
	        'collapsible'=> true,
	      //  'animated'=>'bounceslide',
	        'autoHeight'=>false,
	      'active'=>false,
    ),
)); 
    
}




?>