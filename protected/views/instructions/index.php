
<div id="pagetit">Текстові інструкції</div>

<?

$rows=GenOtherInfo::model()->findAllByAttributes(array('kind_of_publication'=>'8'));  
    echo "<div id='accclassic'>";            
foreach($rows as $row) 
{ 

         $this->widget('zii.widgets.jui.CJuiAccordion',array(
        'panels'=>array(
        $row['title']=>
        ($row['text']),
         ),

    'options'=>array(
    'collapsible'=> true,
     'autoHeight'=>false,
	  'active'=>false,
          
    ),
));

  
}

echo "</div>";
?>