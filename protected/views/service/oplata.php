<?php
/* @var $this ServiceController */



if (GenServices::model()->findByPk($_GET['param'])->is_payed==1){
//echo ;
        $this->widget('zii.widgets.jui.CJuiAccordion',array('id'=>'opys1', 
    'panels'=>array(
        'Платність (безоплатність) надання адміністративної послуги'=>'Платно',
        'Нормативно-правові акти, на підставі яких стягується плата'=>GenServices::model()->findByPk($_GET['param'])->payed_regulations,
        'Розмір та порядок внесення плати (адміністративного збору) за платну адміністративну послугу'=>GenServices::model()->findByPk($_GET['param'])->payed_rate,
        'Розрахунковий рахунок для внесення плати'=>GenServices::model()->findByPk($_GET['param'])->bank_info,
          ),
    // additional javascript options for the accordion plugin
    'options'=>array(
	        'collapsible'=> true,
	        //'animated'=>'bounceslide',
	        'autoHeight'=>false,
	      'active'=>false,
    ),
));
}
else
{
      $this->widget('zii.widgets.jui.CJuiAccordion',array('id'=>'opys1', 
    'panels'=>array(
        'Платність (безоплатність) надання адміністративної послуги'=>'Безоплатно',
                  ),
    // additional javascript options for the accordion plugin
    'options'=>array(
	        'collapsible'=> true,
	     //   'animated'=>'bounceslide',
	        'autoHeight'=>false,
	      'active'=>false,
    ),
));
    
}






?>