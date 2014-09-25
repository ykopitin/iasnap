<?php
/* @var $this ServiceController */

//$this->breadcrumbs=array(
//	'Service',
//);
//if (isset($_GET['class']))
//{
//if ($_GET['class']==1) {$cl="Громадянам";}
//if ($_GET['class']==2) {$cl="Організаціям";}     
//}
  //   if(isset($this->breadcrumbs)):
//	 $this->widget('zii.widgets.CBreadcrumbs', array(
			
    //'links'=>$this->breadcrumbs,        $cl=>array('/service'),
//		)); 
        
       
 //endif
//$this->breadcrumbs=array(
	
	


 if (isset($_GET['param']) && isset($_GET['servid'])){  
 
    echo '<div id=posname><img src="http://allium2.soborka.net/iasnap/images/str.png">&nbsp;'.GenServices::model()->findByPk($_GET['param'])->name.'</div>';
    
 /*       
  $this->widget('zii.widgets.jui.CJuiTabs', array(
    'tabs'=>array(
        'Опис послуги'=>array('id'=>'tab1', 'content'=>$this->renderPartial('my'), array('Values'=>'This Is My Renderpartial Page'),TRUE),
        
        'Документи'=>array('content'=>'Content for tab 2', 'id'=>'tab2'),
        
        'Місця звернення'=>array('content'=>'Content for tab 3', 'id'=>'tab3'),
        
        'Оплата'=>array('content'=>'Content for tab 4', 'id'=>'tab4'),
    ),
    // additional javascript options for the tabs plugin
    'options'=>array(
        'collapsible'=>true,
    ),
));   
 */
 
?>
<div id='mainTabs'>
<?
 $this->widget('CTabView',array(
    //'activeTab'=>'tab2',
    'tabs'=>array(
        'tab1'=>array(
            'title'=>'Опис Послуги',
            'view'=>'opys'
        ),
        'tab2'=>array(
            'title'=>'Документи',
            'view'=>'docs'
        ),
        'tab3'=>array(
            'title'=>'Місця Звернення',
            'view'=>'misce'
        ),
        
        'tab4'=>array(
            'title'=>'Оплата',
            'view'=>'oplata'
        ),
                'tab5'=>array(
            'title'=>'Результат надання послуги',
            'view'=>'resultat'
        ),
 ),
    'activeTab'=>'tab1',
    'cssFile'=>Yii::app()->baseUrl.'/css/jquery.yiitab.css',
    'htmlOptions'=>array('autoHeight'=>true,
    )
));
  
?> </div> <?  
//  Yii::app()->controller->renderPartial('//../modules/user/views/user/login'
  
  
?>

<?
 if (GenServices::model()->findByPk($_GET['param'])->is_online=='так')
{
?>
<table width="200px"><tr><td><div id="otonline"><a href="#">ОТРИМАТИ ПОСЛУГУ ></a></div></td></tr></table>
<?
}}





//***************************************************************

if (isset($_GET['param']) && !isset($_GET['servid']) ){  
 

echo '<div id=searchserv>';
 ?><< <a href="#" onclick="history.back();">Назад</a><br /><br /><?
echo '<div id=posname><img src="http://allium2.soborka.net/iasnap/images/str.png">&nbsp;'.GenServices::model()->findByPk($_GET['param'])->name.'</div>';
    
 /*       
  $this->widget('zii.widgets.jui.CJuiTabs', array(
    'tabs'=>array(
        'Опис послуги'=>array('id'=>'tab1', 'content'=>$this->renderPartial('my'), array('Values'=>'This Is My Renderpartial Page'),TRUE),
        
        'Документи'=>array('content'=>'Content for tab 2', 'id'=>'tab2'),
        
        'Місця звернення'=>array('content'=>'Content for tab 3', 'id'=>'tab3'),
        
        'Оплата'=>array('content'=>'Content for tab 4', 'id'=>'tab4'),
    ),
    // additional javascript options for the tabs plugin
    'options'=>array(
        'collapsible'=>true,
    ),
));   
 */
 
?>
<div id='mainTabs'>
<?
 $this->widget('CTabView',array(
    //'activeTab'=>'tab2',
    'tabs'=>array(
        'tab1'=>array(
            'title'=>'Опис Послуги',
            'view'=>'opys'
        ),
        'tab2'=>array(
            'title'=>'Документи',
            'view'=>'docs'
        ),
        'tab3'=>array(
            'title'=>'Місця Звернення',
            'view'=>'misce'
        ),
        
        'tab4'=>array(
            'title'=>'Оплата',
            'view'=>'oplata'
        ),
                'tab5'=>array(
            'title'=>'Результат надання послуги',
            'view'=>'resultat'
        ),
 ),
    'activeTab'=>'tab1',
    'cssFile'=>Yii::app()->baseUrl.'/css/jquery.yiitab.css',
    'htmlOptions'=>array('autoHeight'=>true,
    )
));
  
?> </div> <?  
//  Yii::app()->controller->renderPartial('//../modules/user/views/user/login'
  
  
?>

<?
 if (GenServices::model()->findByPk($_GET['param'])->is_online=='так')
{
?>
<table width="200px"><tr><td><div id="otonline"><a href="#">ОТРИМАТИ ПОСЛУГУ ></a></div></td></tr></table>
<?
}
?></div><?
}
?>