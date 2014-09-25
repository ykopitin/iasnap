<?php /* @var $this Controller */ 
?>
<?php

 $this->beginContent('//layouts/main');
//$this->setPageTitle('Організаціям');


    ?>
    	<div id="navig">
		<?php 
       // ?class=2&&servid=4
        
        if (isset($_GET['class'])){ 
          echo CHtml::link(GenServClasses::model()->findByPk($_GET['class'])->item_name, array('serv/?class='.$_GET['class']));
         if (isset($_GET['servid'])) { 
            echo ' >> '.CHtml::link(GenServCategories::model()->findByPk(GenCatClasses::model()->findByPk($_GET['servid'])->categorie_id)->name, array('serv/?class='.$_GET['class'].'&&servid='.$_GET['servid']));}
      if (isset($_GET['param'])) { 
            echo ' >> <font color=green>'.GenServices::model()->findByPk($_GET['param'])->name.'</font>';}
       // echo GenServClasses::model()->findByPk($_GET['class'])->item_name;
      //  echo GenServCategories::model()->findByPk(GenCatClasses::model()->findByPk($_GET['servid'])->categorie_id)->name;
      //echo '<p><b><font size=3 color=green>'.GenServices::model()->findByPk($_GET['param'])->name.'</font></b></p>'
        } 
        else {echo "<br><br>";}
         ?>
	</div><?
//$this->breadcrumbs=array(
//	GenServClasses::model()->findByPk($_GET['class'])->item_name=>array('/serv'),
//	GenServCategories::model()->findByPk(GenCatClasses::model()->findByPk($_GET['servid'])->categorie_id)->name,
//);


?>
<div class="span-5 last">
	<div id="sidebar">


     
<?
  if (isset($_GET['class']) ) 
  {
   
 ?><div id="org" class="mmm">  <?  
   if ($_GET['class']=='1'){
   
      $this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
  
    "<span id='qwqw' style='color:white'>ОРГАНІЗАЦІЯМ</span>"=>$this->renderPartial('/serv/org', null,true),
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
      "<span id='qwqw' style='color:white'>ГРОМАДЯНАМ</span>"=>$this->renderPartial('/serv/grom', null,true),
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
        "<span id='qwqw' style='color:white'>ОРГАНІЗАЦІЯМ</span>"=>$this->renderPartial('/serv/org', null,true),
        
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
        
        "<span id='qwqw' style='color:white'>ГРОМАДЯНАМ</span>"=>$this->renderPartial('/serv/grom', null,true),
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
        "<span id='qwqw' style='color:white'>ОРГАНІЗАЦІЯМ</span>"=>$this->renderPartial('/serv/org', null,true),
        
            ),
    
    'options'=>array(
    'icons'=>array(
            "header"=>"ui-icon-plus",//ui-icon-circle-arrow-e
            "headerSelected"=>"ui-icon-circle-arrow-s",//ui-icon-circle-arrow-s, ui-icon-minus
             "position"=>"right"),
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
      
        "<span id='qwqw' style='color:white'>ГРОМАДЯНАМ</span>"=>$this->renderPartial('/serv/grom', null,true),
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
   
     ?> </div> 
	</div><!-- sidebar -->
</div>

<div class="span-19">
	<div id="content">
		<?php echo $content; 
         ?>
	</div><!-- content -->
</div>
<?php $this->endContent(); ?>


