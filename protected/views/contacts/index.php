
<div id="pagetit">Контакти центрів</div>

<?

$rows=GenAuthorities::model()->findAllByAttributes(array('is_cnap'=>'ЦНАП'));  
      echo "<div id='accclassic'>";            
foreach($rows as $row) 
{     
         $this->widget('zii.widgets.jui.CJuiAccordion',array( 
        'panels'=>array(
        $row['name']=>
        (
'<b>Адреса:</b> '.$row['street'].', '.$row['building'].'<br>'.

 '<b>Режим роботи:</b> '.$row['working_time'].'<br>'.

 '<b>E-mail:</b> '.$row['email'].'<br>'.

'<b>Веб-сайт:</b> '.$row['web'].'<br>'.

'<b>Телефон:</b> '.$row['phone'].'<br>'.

'<b>Факс:</b> '.$row['fax'].'<br>'
        
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


}
echo "</div>";

?>