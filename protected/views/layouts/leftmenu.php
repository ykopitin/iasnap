     
<?
  if (isset($_GET['class']) ) 
  {
   
 ?><div id="org" class="mmm">  <?  
   if ($_GET['class']=='1'){
   
      $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
  
    "<span id='qwqw' style='color:black'>Для організацій</span>"=>$this->renderPartial('/serv/org', null,true),
       ),
    
    'options'=>array(

    'active'=>false,
    'minHeight'=>'270',
    'collapsible'=> true,
    //'animated'=>'bounceslide',
    'autoHeight'=>false,
   
	            ),
)); 

?></div><div id="grom" class="mmm">  <?  
 $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
      "<span id='qwqw' style='color:black'>Для громадян</span>"=>$this->renderPartial('/serv/grom', null,true),
       ),
    
    'options'=>array(

    'active'=>0,
    'minHeight'=>'270',
    'collapsible'=> true,
    //'animated'=>'bounceslide',
    'autoHeight'=>false,
   
	            ),
));

?></div> <?  
}
   
   
    if ($_GET['class']=='2'){
   ?><div id="org" class="mmm">  <?  
        $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
        "<span id='qwqw' style='color:black'>Для організацій</span>"=>$this->renderPartial('/serv/org', null,true),
        
            ),
    
    'options'=>array(

    'active'=>0,
    'minHeight'=>'270',
    'collapsible'=> true,
    //'animated'=>'bounceslide',
    'autoHeight'=>false,
    
	            ),
));
     
     ?></div><div id="grom" class="mmm">  <?  
     
        $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
        
        "<span id='qwqw' style='color:black'>Для громадян</span>"=>$this->renderPartial('/serv/grom', null,true),
            ),
    
    'options'=>array(
      
    'active'=>false,
    'minHeight'=>'270',
    'collapsible'=> true,
    //'animated'=>'bounceslide',
    'autoHeight'=>false,
    
	            ),
));

?></div> <?  
}  }
else 
    {
          ?><div id="org" class="mmm">  <?  
          
           $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
        "<span id='qwqw' style='color:black'>Для організацій</span>"=>$this->renderPartial('/serv/org', null,true),
        
            ),
    
    'options'=>array(

    'active'=>false,
    'minHeight'=>'270',
    'collapsible'=> true,
    //'animated'=>'bounceslide',
    'autoHeight'=>false,
     
	            ),
));

?></div><div id="grom" class="mmm">  <?  
 $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
      
        "<span id='qwqw' style='color:black'>Для громадян</span>"=>$this->renderPartial('/serv/grom', null,true),
            ),
    
    'options'=>array(

    'active'=>false,
    'minHeight'=>'270',
    'collapsible'=> true,
    //'animated'=>'bounceslide',
    'autoHeight'=>false,
     
	            ),
));?></div> <?  
}
   
     ?>
     
  <br />
<div id="links">



<table>
	<tr>
		<td colspan="2"><font size=5 color=#16bae9>Відобразити&nbsp;послуги:</font></td>
	</tr>
	<tr>
		<td colspan="2"><a href="#">За життєвими ситуаціями</a></td>
	</tr>
	<tr>
		<td><a href="#">Всі&nbsp;онлайн&nbsp;послуги</a></td>
		<td><div id="isonline">online</div></td>
	</tr>
	<tr>
		<td colspan="2"><a href="#" >Популярні послуги</a></td>
	</tr>
</table>


</div>
