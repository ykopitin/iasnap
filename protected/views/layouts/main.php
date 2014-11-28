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
  

  
  
  
	<title><?php echo CHtml::encode($this->pageTitle); ?></title>



<script type="text/javascript" src="//yastatic.net/share/share.js"
charset="utf-8"></script>




    <script> 
function func(n) { 
if (n==0) {
  document.getElementById("m0").style.display = "block"; 
    document.getElementById("m1").style.display = "none"; 
      document.getElementById("m2").style.display = "none";  

    document.getElementById("n0").style.backgroundColor = "#a2d507"; 
    document.getElementById("n1").style.backgroundColor = "#ededed"; 
    document.getElementById("n2").style.backgroundColor = "#ededed"; 

  document.getElementById("p0").style.background = "url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top"; 
    document.getElementById("p1").style.background = "url('')"; 
    document.getElementById("p2").style.background = "url('')"; 
  
	} 
else if (n==1) {
	  document.getElementById("m0").style.display = "none"; 
    document.getElementById("m1").style.display = "block"; 
      document.getElementById("m2").style.display = "none";  

    document.getElementById("n0").style.backgroundColor = "#ededed"; 
    document.getElementById("n1").style.backgroundColor = "#a2d507"; 
    document.getElementById("n2").style.backgroundColor = "#ededed"; 

  document.getElementById("p1").style.background = "url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top"; 
    document.getElementById("p0").style.background = "url('')"; 
    document.getElementById("p2").style.background = "url('')"; 
	}

else if (n==2) {
	  document.getElementById("m0").style.display = "none"; 
    document.getElementById("m1").style.display = "none"; 
      document.getElementById("m2").style.display = "block";  

    document.getElementById("n0").style.backgroundColor = "#ededed"; 
    document.getElementById("n1").style.backgroundColor = "#ededed"; 
    document.getElementById("n2").style.backgroundColor = "#a2d507"; 

  document.getElementById("p2").style.background = "url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top"; 
    document.getElementById("p0").style.background = "url('')"; 
    document.getElementById("p1").style.background = "url('')"; 
	}


} 
</script>

<style>

</style>
</head>
<body>

<div id="allpage">


<div id="topik">
<div id="topmenu">
	<table border="0" height="20" cellspacing="0" cellpadding="0">
	<tr><td width="75%" bgcolor="#18262A" >

<div id="mainmenu">
		<?php  
     
$data=array();
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
            
             <?php
             echo CHtml::image(Yii::app()->request->baseUrl.'/images/login.png'); 
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
          	<table align="center" border="0" width="1000"  cellspacing="0" cellpadding="0" style="background-color: white;">
			<tr>
				
                <td width="138">
				<a href="/"><img src="<?php echo Yii::app()->baseUrl; ?>/images/logo.jpg" ></a></td>
                <td width="130"><p><font size=1 color=#000>Центр надання адміністративних послуг в Одеській області</font></p>
				</td>
                
                
				<td style="vertical-align: bottom; background: url('<?php echo Yii::app()->baseUrl; ?>/images/search.jpg')  no-repeat left top; " width="458" height="108">
            
            <form action="<?php echo Yii::app()->baseUrl; ?>/searchmy" method="GET">
           <table style="width: 380px;margin-top: 26px; margin-left: 10px;"><tr><td><input type="text" name="searchstr" value="Пошук по сайту" id="search" onblur="if(this.value=='') this.value='Пошук по сайту';" onfocus="if(this.value=='Пошук по сайту') this.value='';"/></td>
           <td style="text-align: left;vertical-align: bottom;">
           
           
           
           <input type="image" src="/images/search-btn.png" onClick=submit() id="searchbtn"/>
           
           
           
           </td></tr>
           <tr><td><div id="napr">&nbsp;&nbsp;&nbsp;Наприклад: <input type="submit" value="Зовнішня реклама" name="searchstr" value="Зовнішня реклама"id="sbtn"></div></td><td></td></tr></table> 
			</form>
            
            </td>
				<td  align="center">Гаряча лінія:<br>
				<br>
				<h1><font color="gray">(048)</font> <font color="#313131">705-45-74</font></h1></td>
			</tr>
		</table><div id="testr"><span id="anchor1"></span><font color=gray size=1 >&nbsp;Сайт центру надання адміністративних послуг працює у тестовому режимі.</font></div>



 </div> 

 <?php 
 
 
 
 
 
if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/' || $_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/index.php' ||isset($_GET['func'])) {
    ?>
	<table background="/images/zz.jpg" width="100%" height="18px" ><tr><td ></td></tr></table>
<?php } ?>
  <div class="container" id="page">

		<?php 
          
        if (isset($_GET['servid']) || isset($_POST['searchstr'])){ 
            echo '<div id="navigbg"><div id="navig">';
          if (isset($_GET['class'])){ echo CHtml::link('Головна', array('..'));

  if ($_GET['class']==1){
          echo ' <img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;'.CHtml::link(GenServClasses::model()->findByPk($_GET['class'])->item_name, array('/?func=1'));
}
  if ($_GET['class']==2){
          echo ' <img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;'.CHtml::link(GenServClasses::model()->findByPk($_GET['class'])->item_name, array('..'));
}

         if (isset($_GET['servid'])) { 
            echo ' <img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;'.CHtml::link(GenServCategories::model()->findByPk(GenCatClasses::model()->findByPk($_GET['servid'])->categorie_id)->name, array('serv/?class='.$_GET['class'].'&&servid='.$_GET['servid']));}
      if (isset($_GET['param'])) { 
            echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp';}
        }
         if (isset($_POST['searchstr'])){ 
         echo CHtml::link('Головна', array('Yii::app()->baseUrl'));
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbspПошук';
        } 
         echo	'</div></div>';
        } 
      
      
      if (isset($_GET['sub'])){
        echo '<div id="navigbg"><div id="navig">';
         echo CHtml::link('Головна', array('..'));
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;<a href='.Yii::app()->baseUrl.'/sub>Послуги за суб&#39єктами надання</a>';
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;<a href='.Yii::app()->baseUrl.'/serv/?sub='.$_GET['sub'].'>'.GenAuthorities::model()->findByPk($_GET['sub'])->name.'</a>';
  
          echo	'</div></div>';
      } 
      
      
            if (isset($_GET['idn'])){
        echo '<div id="navigbg"><div id="navig">';
         echo CHtml::link('Головна', array('..'));
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Новини';
         
          echo	'</div></div>';
      } 
                        if (isset($_GET['tracksts'])){
        echo '<div id="navigbg"><div id="navig">';
         echo CHtml::link('Головна', array('..'));
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Відстеження стану заявки';
         
          echo	'</div></div>';
      } 
            if (isset($_GET['cid'])){
        echo '<div id="navigbg"><div id="navig">';
         echo CHtml::link('Головна', array('..'));
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;<a href=/contacts>Контакти центрів</a>';
         
          echo	'</div></div>';
      } 
      
                  if (isset($_GET['searchstr'])){
        echo '<div id="navigbg"><div id="navig">';
         echo CHtml::link('Головна', array('..'));
         $str=rawurlencode($_GET['searchstr']);
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;<a href=/searchmy?searchstr='.$str.'>Результати пошуку</a>';
         
          echo	'</div></div>';
      } 
      
            if (isset($_GET['life'])){
        echo '<div id="navigbg"><div id="navig">';
         echo CHtml::link('Головна', array('..'));
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;<a href='.Yii::app()->baseUrl.'/?func=2>Послуги за життєвими ситуаціями</a>';
         echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;<a href='.Yii::app()->baseUrl.'/serv/?life='.$_GET['life'].'>'.GenLifeSituation::model()->findByPk($_GET['life'])->name.'</a>';
  
          echo	'</div></div>';
      } 
      
       
        if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/ecnap')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;e-ЦНАП';
          echo	'</div></div>';
        }     

        if (isset($_GET['idregistry'])&&isset($_GET['idstorage']))
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Замовлення on-line послуги';
          echo	'</div></div>';
        }  

        if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/contacts')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Контакти центрів';
          echo	'</div></div>';
        }   
        
                if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/regulations')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Законодавство';
          echo	'</div></div>';
        }   
                        if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/cabinet')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Особистий кабінет користувача';
          echo	'</div></div>';
        }  
        
        
                        if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/sign/login')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Вхід';
          echo	'</div></div>';
        }
        
                if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/instructions')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Текстові інструкції';
          echo	'</div></div>';
        }   
                if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/cherga')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Запис в чергу on-line';
          echo	'</div></div>';
        }   
                if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/video')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Відео інструкції';
          echo	'</div></div>';
        }   

        if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/sub')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array($this->createUrl('..')));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Послуги за суб&#39єктами надання';
          echo	'</div></div>';
        } 
        
                if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/life')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Послуги за життєвими ситуаціями';
          echo	'</div></div>';
        } 
                        if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/tracking')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Відстеження стану заявки';
          echo	'</div></div>';
        } 
        
                        if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/ecp')
        {
          echo '<div id="navigbg"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Як отримати ЕЦП';
          echo	'</div></div>';
        } 



     if (isset($_GET['param'])){  
 
    echo '<div id="posnamebg"><div id=posname>'.GenServices::model()->findByPk($_GET['param'])->name.'</div></div>';
   
  if (isset($_GET['class']) && isset($_GET['servid']) ) {$tempclass=$_GET['class']; $tempcat=$_GET['servid'];} else {
    


   $rr=GenServCatClass::model()->findAllByAttributes(array('service_id'=>$_GET['param'])); 

$countrr=count($rr) ;
if ($countrr>0){
     foreach($rr as $row) 
        {
            $temp=$row['cat_class_id'];
    }
    $tempclass=GenCatClasses::model()->findByPk($temp)->class_id;
   $tempcat=GenCatClasses::model()->findByPk($temp)->categorie_id;
    }else {$tempclass=0;$tempcat=0;}
   
   
   
    }
   
    echo '<br><div id=printbg><div id=print><table><tr><td><a href='.Yii::app()->request->baseUrl.'/print?class='.$tempclass.'&&param='.$_GET['param'].'&&servid='.$tempcat.' target=_blank>Версія для друку</a></td><td width=6px><img src='.Yii::app()->baseUrl.'/images/print.jpeg></td></tr></table></div></div>';

    }
    
    
    
    
    
//    echo Yii::app()->baseUrl.'/index.php/ecnap<br>';

 //  echo $_SERVER['REQUEST_URI'];
    
  //  echo Yii::app()->baseUrl;
   
    
    
    
  if (isset($_GET['func'])|| $_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/'  || $_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/index.php'  ||(isset($_GET['class']) && !isset($_GET['param']) && !isset($_GET['servid']))){
  echo  '<div id="mainbg">';}
  else {echo  '<div id="allbg">';}
   ?>   
  <div id="cat"> 

  	<?php echo $content;?>
    </div>


</div>

<?php 
if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/' || $_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/index.php' ||isset($_GET['func'])) {

include 'news.php';
echo '<div id="mainbg">';
include 'derzh.php';
echo '</div>';

}



?>




</div>

<!-- mibew button -->
<div id="consultantbg"><div id="consultant">
<a href="/mibew/client.php?locale=ua&amp;style=default" target="_blank" onclick="if(navigator.userAgent.toLowerCase().indexOf('opera') != -1 &amp;&amp; window.event.preventDefault) window.event.preventDefault();this.newWindow = window.open(&#039;/mibew/client.php?locale=ua&amp;style=default&amp;url=&#039;+escape(document.location.href)+&#039;&amp;referrer=&#039;+escape(document.referrer), 'mibew', 'toolbar=0,scrollbars=0,location=0,status=1,menubar=0,width=640,height=480,resizable=1');this.newWindow.focus();this.newWindow.opener=window;return false;" class="smright"><img src="/images/cons.png"></a></div></div>
<!-- / mibew button -->
<!-- mainmenu --> 


<div class="page-buffer"></div></div>
<?php
if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/' || $_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/index.php' ||isset($_GET['func'])) {
?>
	<table background="<?php echo Yii::app()->baseUrl; ?>/images/bz.png" width="100%" height="20px" style="margin-bottom: -10px; background-color: #ededed;"><tr><td ></td></tr></table>

<?php
}
else{
    ?>
	<table background="<?php echo Yii::app()->baseUrl; ?>/images/bz.png" width="100%" height="20px" style="margin-bottom: -10px; background-color: #fff;"><tr><td ></td></tr></table>

<?php
}
    
?>
<div id="footer">
<div id="topmenu">	<table ><tr><td width="86%"><div id="mainmenu">

		<?php      
  $this->widget('ext.cssmenu.CssMenu',array(	'items'=>$dat));
                
                
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
				Координатора проектів ОБСЄ в Україні</font></td>
				<td><a href=http://www.osce.org/uk/ukraine target=_blank><img src="<?php echo Yii::app()->baseUrl; ?>/images/osce.jpg" ></a></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td width="33%" style="border:none; vertical-align:bottom"><font color="#FFFFFF" size="2">
		Всі права захищено. Використання матеріалів сайту можливе лише з 
		посиланням на першоджерело.</font></td>
		<td width="33%" style="border:none; vertical-align:bottom"><font color="#FFFFFF" size="2">
		Підтримка КП &quot;Обласний інформаційно-аналітичний центр&quot; © 2014 р.</font></td>
	</tr>
</table>
</div>

</div><!-- footer -->

<!-- page -->
   

</body>
</html>
