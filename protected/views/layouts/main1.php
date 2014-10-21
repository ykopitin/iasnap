<?php /* @var $this Controller */ ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="language" content="en" />

	<!-- blueprint CSS framework -->
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/screen.css" media="screen, projection" />
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/print.css" media="print" />
	<!--[if lt IE 8]>
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/ie.css" media="screen, projection" />
	<![endif]-->

	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/main1.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/form.css" />
	<title><?php echo CHtml::encode($this->pageTitle); ?></title>
</head>

<body>
	<table border="0" height="20" cellspacing="0" cellpadding="0">
	<tr><td width="65%" bgcolor="#18262A" >

<div id="mainmenu">
		<?php  
     

 $this->widget('ext.cssmenu.CssMenu',array(
			'items'=>array(	
            array('label'=>'Перейти на сайт', 'url'=>'http://allium2.soborka.net/iasnap/'),
            	),
				));
   
    
                
             ?>  </div>
	<!-- mainmenu --> 
             </td> <td width="35%" bgcolor="#18262A" align="left">   <div id="loginmenu"> 
             <?php
           // echo CHtml::image(Yii::app()->request->baseUrl.'/images/zm.jpg'); 
             $this->widget('zii.widgets.CMenu',array(
			'items'=>array(	
            //array('label'=>'Кабінет', 'url'=>array('/cabinet'), 'visible'=>!Yii::app()->user->isGuest),
            array('label'=>'Увійти', 'url'=>Yii::app()->CreateUrl('sign/login'), 'visible'=>Yii::app()->user->isGuest),
            array('label'=>'Вийти', 'url'=>Yii::app()->CreateUrl('site/logout'), 'visible'=>!Yii::app()->user->isGuest),
            //array('label'=>'Реєстрація', 'url'=>Yii::app()->CreateUrl('#'), 'visible'=>Yii::app()->user->isGuest),
            	),
		));
	?> </div>
  	</td>
	</tr>
</table> 

<div class="container" id="logo">
          	<table align="center" border="0" width="1259"  cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
			<tr>
				<td width="336">
				<img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/logo.jpg" ></td>
				<td background="<?php echo Yii::app()->baseUrl; ?>/images/search.jpg" width="458" height="97">
             
                <input type="text" id="text" >
				</td>
				<td  align="center">Гаряча лінія:<br>
				<br>
				<h1>(048) 705-45-74</h1></td>
			</tr>
		</table>
 </div>
 <table background="<?php echo Yii::app()->baseUrl; ?>/images/zz.jpg" width="100%" height="19"><tr><td></td></tr></table>
 <div class="container" id="page">
 
  <div id="cat"> 
    <?php if(isset($this->breadcrumbs)):?>
		<?php $this->widget('zii.widgets.CBreadcrumbs', array(
			'links'=>$this->breadcrumbs,
			'homeLink'=>false,
		)); ?><!-- breadcrumbs -->
	<?php endif;?>

	<?php echo $content; ?> 
    </div>
</div>
	<div class="clear"></div>





<!-- mainmenu --> 


<div id="footer">
		<table background="<?php echo Yii::app()->baseUrl; ?>/images/but_z.jpg" width="100%" height="20"><tr><td ></td></tr></table>
	<table ><tr><td ><div id="mainmenu">

	 </div></td></tr></table>	

<div id="about">
<table border="0" width="100%" id="table4">
	<tr>
		<td width="33%"><font size="2" color="#A2D507">Адреса:</font><font size="2"><font color="#FFFFFF"> 
		65026, м. Одеса, вул. Преображенська, 21</font><br>
		<br>
		<font color="#A2D507">Телефон:</font><br>
		<br>
		</font><font size="5">(048) </font><font size="5" color="#FFFFFF">
		705-45-74</font><font size="2"><br>
		<br>
		<font color="#A2D507">З усіх питань пишіть на</font>: </font>
		<font color="#FFFFFF"><font size="2">admin.center3@omr.odessa.ua</font></font></td>
		<td width="33%" style="border:none; vertical-align:bottom"><font color="#FFFFFF" size="2">Всі права захищено. 
		Використання матеріалів сайту можливе лише з посиланням на першоджерело.</font></td>
		<td width="33%" style="border:none; vertical-align:bottom"><font color="#FFFFFF" size="2">Підтримка КП &quot;Обласний 
		інформаційно-аналітичний центр&quot; © 2013 р.</font></td>
	</tr>
</table>
</div>

</div><!-- footer -->

<!-- page -->  

</body>
</html>
