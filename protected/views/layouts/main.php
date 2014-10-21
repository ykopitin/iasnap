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

	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/main.css" />
    <link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/style.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/form.css" />
    	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/leftacc.css" />
        <link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/acc.css" />
        <link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/path.css" />
     	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/li-scroller.css" />
	<title><?php echo CHtml::encode($this->pageTitle); ?></title>

<script type="text/javascript" src="<?php echo Yii::app()->request->baseUrl; ?>/js/jquery.li-scroller.1.0.js"></script>
<script type="text/javascript" src="<?php echo Yii::app()->request->baseUrl; ?>/js/packed.js"></script>
<script type="text/javascript" src="<?php echo Yii::app()->request->baseUrl; ?>/js/script.js"></script>

<script type="text/javascript" src="//yastatic.net/share/share.js"
charset="utf-8"></script>

<script type="text/javascript">
$(function(){
	$("ul#ticker01").liScroll();
//Syntax
});
</script>

    <script> 
function func(n) { 
    document.getElementById("m"+(n^1)).style.display = "none"; 
    document.getElementById("m"+n).style.display = "block"; 
    
        document.getElementById("n"+(n^1)).style.backgroundColor = "#fff"; 
    document.getElementById("n"+n).style.backgroundColor = "#a2d507"; 
    
            document.getElementById("p"+(n^1)).style.background = "url('')"; 
    document.getElementById("p"+n).style.background = "url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top"; 
} 
</script>

<style>
#page
{
	min-height: 100%;
    margin-top: -20px;
	margin-bottom: 0px;
	<?php if (!isset($_GET['param'])) {?><?}?>
	width: 100%;
}
</style>
</head>
<body>

<div id="topik">
<div id="topmenu">
	<table border="0" height="20" cellspacing="0" cellpadding="0">
	<tr><td width="75%" bgcolor="#18262A" >

<div id="mainmenu">
		<?php  
     

 $result=GenMenuItems::model()->findAll();    
       
       
 foreach ($result as $value){
 $data[$value['id']]=array('paderntid'=>$value['paderntid'],'label'=>$value['content'], 'url'=>$value['url']);
 }
 function ddmenu($dataset) {
 $tree = array();
 foreach ($dataset as $id=>&$node) {
 if (!$node['paderntid']) {
 $tree[$id] = &$node;
 }
 else {
 $dataset[$node['paderntid']]['items'][$id] = &$node;
 }
 }
 return $tree;
 }
 
 $dat = ddmenu($data);
 
 

 
 
 

  $this->widget('ext.cssmenu.CssMenu',array('items'=>$dat));
           ?>  
	<!-- mainmenu --> 
             </td> <td width="22%" bgcolor="#18262A" >   <div id="loginmenu"> 
             <img src="<?php echo Yii::app()->baseUrl; ?>/images/login.png" >
             <?
           // echo CHtml::image(Yii::app()->request->baseUrl.'/images/zm.jpg'); 
             $this->widget('zii.widgets.CMenu',array(
			'items'=>array(	
            array('label'=>'Кабінет', 'url'=>array('/cabinet'), 'visible'=>!Yii::app()->user->isGuest),
            array('label'=>'Увійти', 'url'=>Yii::app()->CreateUrl('sign/login'), 'visible'=>Yii::app()->user->isGuest),
            array('label'=>'Вийти', 'url'=>Yii::app()->CreateUrl('sign/logout'), 'visible'=>!Yii::app()->user->isGuest),
            array('label'=>'Реєстрація', 'url'=>Yii::app()->CreateUrl('sign/register'), 'visible'=>Yii::app()->user->isGuest),
            	),
		));
	?> </div></div>
  	</td>
	</tr>
</table>  
</div></div>
<div class="container" id="logo">
          	<table align="center" border="0" width="1259"  cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
			<tr>
				
                <td width="138">
				<a href="<?php echo Yii::app()->baseUrl; ?>"><img src="<?php echo Yii::app()->baseUrl; ?>/images/logo.jpg" ></a></td>
                <td width="130"><p>Центр надання адміністративних послуг в Одеській області</p>
				</td>
                
                
				<td background="<?php echo Yii::app()->baseUrl; ?>/images/search.jpg" width="458" height="97">
             <form action="<?php echo Yii::app()->baseUrl; ?>/index.php/search" method="post">
                <input type="text" name="searchstr" id="search" ></form>
				</td>
				<td  align="center">Гаряча лінія:<br>
				<br>
				<h1>(048) 705-45-74</h1></td>
			</tr>
		</table>
 </div>



 <hr /><br />
  <div class="container" id="page">

		<?php 
          
        if (isset($_GET['servid']) || isset($_POST['searchstr'])){ 
            echo '<div id="navigbg"><div id="navig">';
          if (isset($_GET['class'])){ echo CHtml::link('Головна', array('/'));
          echo ' <img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;'.CHtml::link(GenServClasses::model()->findByPk($_GET['class'])->item_name, array('serv/?class='.$_GET['class']));
         if (isset($_GET['servid'])) { 
            echo ' <img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;'.CHtml::link(GenServCategories::model()->findByPk(GenCatClasses::model()->findByPk($_GET['servid'])->categorie_id)->name, array('serv/?class='.$_GET['class'].'&&servid='.$_GET['servid']));}
      if (isset($_GET['param'])) { 
            echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp';}
        }
         if (isset($_POST['searchstr'])){ 
echo CHtml::link('Головна', array('/'));
 echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbspПошук';
        } 
        echo	'</div></div>';
        } 
      
        
               ?>

    <?
     if (isset($_GET['param'])){  
 
    echo '<div id="posnamebg"><div id=posname>'.GenServices::model()->findByPk($_GET['param'])->name.'</div></div>';
    }
   
    
    
    
    
    
    
    

   // echo $_SERVER['REQUEST_URI'];
    
  //  echo Yii::app()->baseUrl;
     ?>
    
    
    
    
    
  <div id="cat"> 
  
  	<?php echo $content;?>
    </div></div>

	<div class="clear"></div>

<?php 
if (!isset($_GET['param']) && !isset($_POST['searchstr']) && !isset($_GET['servid'])){
if (!isset($_GET['idn'])) {echo "<br />";include 'banners.php';}
echo "<hr />";
include 'news.php';echo "<hr />";
if (!isset($_GET['idn'])) {include 'derzh.php';}
;
}?>


<!-- mainmenu --> 

<div id="footer">
		<table background="<?php echo Yii::app()->baseUrl; ?>/images/bz.png" width="100%" height="20"><tr><td ></td></tr></table>
<div id="topmenu">	<table ><tr><td width="86%"><div id="mainmenu">

		<?php      
   $this->widget('ext.cssmenu.CssMenu',array(
			'items'=>$dat));
                
                
?> 	 </div></td><td>
 <div class="yashare-auto-init" data-yashareL10n="ru" data-yashareType="none" data-yashareQuickServices="vkontakte,facebook,twitter,odnoklassniki,gplus"></div> 
 </td></tr></table>	</div>

<div id="about">
<table border="0" width="100%" id="table4">
	<tr>
		<td width="33%" rowspan="2"><font size="2" color="#A2D507">Адреса:</font><font size="2"><font color="#FFFFFF"> 
		65026, м. Одеса, вул. Преображенська, 21</font><br>
		<br>
		<font color="#A2D507">Телефон:</font><br>
		<br>
		</font><font size="5">(048) </font><font size="5" color="#FFFFFF">
		705-45-74</font><font size="2"><br>
		<br>
		<font color="#A2D507">З усіх питань пишіть на</font>: </font>
		<font size="2" color="#FFFFFF">admin.center3@omr.odessa.ua</font></td>
		<td width="66%" style="border:none; vertical-align:bottom" colspan="2">
		<table border="1" width="100%" id="table5">
			<tr>
				<td><font color="#FFFFFF" size="4"><br>Проект створено за підтримки 
				координатора проектів ОБСЄ в Україні</font></td>
				<td><img src="<?php echo Yii::app()->baseUrl; ?>/images/osce.jpg" ></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td width="33%" style="border:none; vertical-align:bottom"><font color="#FFFFFF" size="2">
		Всі права захищено. Використання матеріалів сайту можливе лише з 
		посиланням на першоджерело.</font></td>
		<td width="33%" style="border:none; vertical-align:bottom"><font color="#FFFFFF" size="2">
		Підтримка КП &quot;Обласний інформаційно-аналітичний центр&quot; © 2013 р.</font></td>
	</tr>
</table>
</div>

</div><!-- footer -->

<!-- page -->
   

</body>
</html>
