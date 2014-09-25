<?php
/* @var $this DefaultController */
    
$this->breadcrumbs=array(
	'Адміністративна панель',
);
?>

<h1><?php echo "Головна адміністративна сторінка"; ?></h1>

<?php
//$this->menu=array(
//	array('label'=>'Відобразити', 'url'=>array('index')),
//	array('label'=>'Управляти', 'url'=>array('admin')),
//);
//$this->widget('zii.widgets.CMenu', array(
//    'label'=>'ert',
//));
/*$this->widget('zii.widgets.CMenu', array(
    'items'=>array(
        // Important: you need to specify url as 'controller/action',
        // not just as 'controller' even if default acion is used.
        array('label'=>'Home', 'url'=>array('site/index')),
        // 'Products' menu item will be selected no matter which tag parameter value is since it's not specified.
        array('label'=>'Products', 'url'=>array('product/index'), 'items'=>array(
            array('label'=>'New Arrivals', 'url'=>array('product/new', 'tag'=>'new')),
            array('label'=>'Most Popular', 'url'=>array('product/index', 'tag'=>'popular')),
        )),
        array('label'=>'Login', 'url'=>array('site/login'), 'visible'=>Yii::app()->user->isGuest),
    ),
));*/

//$z='id';
//echo $z;
$this->widget('zii.widgets.CMenu', array(
    'items'=>$this->getMenuItems($idis),
));
?>