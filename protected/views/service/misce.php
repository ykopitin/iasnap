<?

        $this->widget('zii.widgets.jui.CJuiAccordion',array('id'=>'opys4', 
        'panels'=>array(
        GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->name=>
        ('
        
        <b>Адреса:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->street.', '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->building.'<br>'.

 '<b>Режим роботи:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->working_time.'<br>'.

 '<b>E-mail:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->email.'<br>'.

'<b>Веб-сайт:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->web.'<br>'.

'<b>Телефон:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->phone.'<br>'.

'<b>Факс:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->fax.'<br>'
        
        ),
       
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