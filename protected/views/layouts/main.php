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
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/form.css" />
    	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/leftacc.css" />
     	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/li-scroller.css" />
	<title><?php echo CHtml::encode($this->pageTitle); ?></title>

<script type="text/javascript" src="<?php echo Yii::app()->request->baseUrl; ?>/js/jquery.li-scroller.1.0.js"></script>


<script type="text/javascript">
$(function(){
	$("ul#ticker01").liScroll();
//Syntax
});
</script>
</head>

<body>
	<table border="0" height="20" cellspacing="0" cellpadding="0">
	<tr><td width="65%" bgcolor="#18262A" >

<div id="mainmenu">
		<?php  
     

 $result=GenMenuItems::model()->findAll();    
       
       
 foreach ($result as $value){
 $data[$value['id']]=array('paderntid'=>$value['paderntid'],'label'=>$value['content']);
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
 
 
 $this->widget('ext.cssmenu.CssMenu',array(
			'items'=>$dat));
   
    
                
             ?>  </div>
	<!-- mainmenu --> 
             </td> <td width="35%" bgcolor="#18262A" align="left">   <div id="loginmenu"> 
             <?php
           // echo CHtml::image(Yii::app()->request->baseUrl.'/images/zm.jpg'); 
             $this->widget('zii.widgets.CMenu',array(
			'items'=>array(	
            array('label'=>'Увійти', 'url'=>Yii::app()->CreateUrl('sign/login')),
            array('label'=>'Реєстрація', 'url'=>Yii::app()->CreateUrl('sign/register')),
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
				<a href="<?php echo Yii::app()->baseUrl; ?>"><img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/logo.jpg" ></a></td>
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


<div id="marq">




				<ul id="ticker01">
						<?php $rows=GenNews::model()->lastnews();
foreach($rows as $row) {
  
	echo '<li><b>'.Yii::app()->dateFormatter->format("dd MMMM yyyy", $row['publicationDate']);
    	echo '&nbsp;&nbsp;<a href='.Yii::app()->baseUrl.'/index.php/news?idn='.$row['id'].'>'.$row['title'].'</a></b></li>';
        	//echo '<font color=#aeaec9>'.$row['summary'].'</font>';    
     	          }
?>
				</ul>





 </div>

 <table background="<?php echo Yii::app()->baseUrl; ?>/images/zz.jpg" width="100%" height="19"><tr><td></td></tr></table>





 




 <div class="container" id="page">
 
  <div id="cat"> 
  
  

    
    

	<?php echo $content;
       
    
    ?>
    </div>
</div>
	<div class="clear"></div>

<div id='news'>

<table width="100%">
	<tr>
		<td colspan="3"><h3>Новини порталу</h3></td>
	</tr>
	<tr>
<?php $rows=GenNews::model()->lastnews();
foreach($rows as $row) {
     echo '<td width=33% valign=top><table>';   
	echo '<tr><td ><b><font color=#16bae9>'.Yii::app()->dateFormatter->format("dd MMMM yyyy", $row["publicationDate"]).'</font></b></td></tr>';
    	echo '<td><b><a href='.Yii::app()->baseUrl.'/index.php/news?idn='.$row['id'].'>'.$row['title'].'</a></b></td></tr>';
        	echo '<td><font color=#aeaec9>'.$row['summary'].'</font></td></tr>';    
     	 echo '</table></td>';
                    }
?>
</tr>
</table>


</div>

<div class="container" id="resourses">
<div id="resourses1">
&nbsp;<h3>Державні ресурси</h3>
<div class="adv">
<table border="0" id="table4" cellspacing="0" cellpadding="8">
	<tr>
		<td align="center">
    	<img src="<?php echo Yii::app()->baseUrl; ?>/images/banner-1.png" alt="" />
	
               
		</td>
		<td align="center">
		<img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/banner-2.jpg" width="150" height="111"></td>
		<td align="center">
		<img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/banner-3.jpg" width="150" height="111"></td>
		<td align="center">
		<img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/banner-4.jpg" width="150" height="111"></td>
		<td align="center">
		<img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/banner-5.jpg" width="150" height="111"></td>
		<td align="center">
		<img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/banner-6.jpg" width="150" height="111"></td>
	</tr>
    	<tr>
		<td align="center" colspan="6">	<img border="0" src="<?php echo Yii::app()->baseUrl; ?>/images/big-banner.jpg"></td>
	</tr>
</table>
</div></div>
</div>

<!-- mainmenu --> 

<div id="footer">
		<table background="<?php echo Yii::app()->baseUrl; ?>/images/but_z.jpg" width="100%" height="20"><tr><td ></td></tr></table>
	<table ><tr><td ><div id="mainmenu">

		<?php   
                    //var_dump($dat);
   $this->widget('ext.cssmenu.CssMenu',array(
			'items'=>$dat));
                
                
             ?> 	 </div></td></tr></table>	

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
