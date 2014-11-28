<?php

if (!isset($_GET['func'])){
?>
<div id="classtitle">
<table>
<tr>
<td style="text-align:left;"><span id="n0" style="background-color: #a2d507;"><a href="#" onclick="func(0)">ОРГАНІЗАЦІЯМ</a> </span></td>
<td style="text-align:center;"><span id="n1"  style="margin-left:30px;"> <a href="#" onclick="func(1)">ГРОМАДЯНАМ</a></span></td>
<td style="text-align:right;"><span id="n2" > <a href="#" onclick="func(2)">ЗА&nbsp;ЖИТТЄВИМИ&nbsp;СИТУАЦІЯМИ</a></span></td>
</tr>
<tr><td><p  id="p0" style="background: url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top;"></p> </td><td><p  id="p1"></p> </td><td><p  id="p2"></p> </td></tr></table>
</div>

<table width="900px"><tr><td width="650px" style="vertical-align: top;">

<div id="servbg" class="container">
<div id="m0">
<?php $this->renderPartial('/serv/org'); ?>
</div>  
<div id="m1">
<?php $this->renderPartial('/serv/grom'); ?>
</div> 
<div id="m2"  style="display:none;">
<?php $this->renderPartial('/serv/sit'); ?>
</div> 

</div>

</td>

<?php
}

if (isset($_GET['func'])){
if ($_GET['func']==2){
?>
<div id="classtitle">
<table>
<tr>
<td style="text-align:left;"><span id="n0"><a href="#" onclick="func(0)">ОРГАНІЗАЦІЯМ</a> </span></td>
<td style="text-align:center;"><span id="n1"  style="margin-left:30px;"> <a href="#" onclick="func(1)">ГРОМАДЯНАМ</a></span></td>
<td style="text-align:right;"><span id="n2"  style="background-color: #a2d507;"> <a href="#" onclick="func(2)">ЗА&nbsp;ЖИТТЄВИМИ&nbsp;СИТУАЦІЯМИ</a></span></td>
</tr>
<tr><td><p  id="p0"></p> </td><td><p  id="p1"></p> </td><td><p  id="p2"  style="background: url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top;"></p> </td></tr></table>
</div>

<table width="900px"><tr><td width="650px" style="vertical-align: top;">

<div id="servbg" class="container">
<div id="m0"  style="display:none;">
<?php $this->renderPartial('/serv/org'); ?>
</div>  
<div id="m1"  style="display:none;">
<?php $this->renderPartial('/serv/grom'); ?>
</div> 
<div id="m2"  style="display:block;">
<?php $this->renderPartial('/serv/sit'); ?>
</div> 

</div>

</td>

<?php
}


if ($_GET['func']==1){
?>
<div id="classtitle">
<table>
<tr>
<td style="text-align:left;"><span id="n0"><a href="#" onclick="func(0)">ОРГАНІЗАЦІЯМ</a> </span></td>
<td style="text-align:center;"><span id="n1"  style="margin-left:30px; background-color: #a2d507;"> <a href="#" onclick="func(1)">ГРОМАДЯНАМ</a></span></td>
<td style="text-align:right;"><span id="n2"> <a href="#" onclick="func(2)">ЗА&nbsp;ЖИТТЄВИМИ&nbsp;СИТУАЦІЯМИ</a></span></td>
</tr>
<tr><td><p  id="p0"></p> </td><td><p  id="p1"  style="background: url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top;"></p> </td><td><p  id="p2"></p> </td></tr></table>
</div>

<table width="900px"><tr><td width="650px" style="vertical-align: top;">

<div id="servbg" class="container">
<div id="m0"  style="display:none;">
<?php $this->renderPartial('/serv/org'); ?>
</div>  
<div id="m1"  style="display:block;">
<?php $this->renderPartial('/serv/grom'); ?>
</div> 
<div id="m2"  style="display:none;">
<?php $this->renderPartial('/serv/sit'); ?>
</div> 

</div>

</td>

<?php
}





}



?>


<td style="vertical-align: top; ">
<div id="servmenu" class="container">


<div id="leftpos">
<table style="height: 400px; border-spacing: 20px; border-collapse: collapse; margin-left: -10px;">
<tr><td style="width: 45px;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/life.png"></td><td style="width: 255px;"><a href="/cherga">Запис в чергу on-line</a></td></tr>
<tr><td style="width: 45px;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/office.png"></td><td><a href="<?php echo Yii::app()->baseUrl; ?>/sub">Послуги за суб'єктами надання</a></td></tr>
<tr><td style="width: 45px;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/search.png"></td><td><a href="/tracking">Відстежити статус заявки</a></td></tr>
<tr><td style="width: 45px;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/computer.png"></td><td><a href="#">Технічні вимоги до комп'ютеру користувача порталу</a></td></tr>
<tr><td style="width: 45px;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/video.png"></td><td><a href="/video">Відео-інструкції по роботі з порталом</a></td></tr>
<tr><td style="width: 45px;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/signature.png"></td><td><a href="/ecp">Як отримати ЕЦП?</a></td></tr>
</table>
</div>


</div></td></tr></table>





