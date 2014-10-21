<?php


 //if (isset($_GET['param']) && isset($_GET['servid'])){  
 
 //   echo '<div id=posname>'.GenServices::model()->findByPk($_GET['param'])->name.'</div>';
    
 
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
             //   'tab5'=>array(
         //   'title'=>'Результат надання послуги',
         //   'view'=>'resultat'
       // ),
        'tab5'=>array(
            'title'=>'Експертиза',
            'view'=>'expert'
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


//}


