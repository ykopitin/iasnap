<div id="classtitle">
<table>
<tr><td><span id="n0" style="background-color: #a2d507;"><a href="#" onclick="func(0)">ОРГАНІЗАЦІЯМ</a> </span></td>

<td><span id="n1"> <a href="#" onclick="func(1)">ГРОМАДЯНАМ</a></span></td>

</tr>
<tr><td><p  id="p0" style="background: url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top;"></p> </td><td><p  id="p1"></p> </td></tr></table>
</div>

<table width="900px"><tr><td width="650px" style="vertical-align: top;">

<div id="servbg" class="container">
<div id="m0">
<?php $this->renderPartial('/serv/org'); ?>
</div>  
<div id="m1">
<?php $this->renderPartial('/serv/grom'); ?>
</div> 


</div>

</td><td style="vertical-align: top; ">
<div id="servmenu" class="container">


<div id="leftpos">
<table><tr><td><img src="<?php echo Yii::app()->baseUrl; ?>/images/life.png"></td><td><a href="#">Послуги за життєвими ситуаціями</a></td></tr>
<tr><td style="text-align: center;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/office.png"></td><td><a href="#">Послуги за суб'єктами надання</a></td></tr>
</table></div>





<div id="lefthelp">
<table><tr><td><img src="<?php echo Yii::app()->baseUrl; ?>/images/computer.png"></td><td><a href="#">Технічні вимоги до комп'ютеру користувача порталу</a></td></tr>

<tr><td><img src="<?php echo Yii::app()->baseUrl; ?>/images/video.png"></td><td><a href="#">Відео урок роботи з порталом</a></td></tr>
<tr><td style="text-align: center;"><img src="<?php echo Yii::app()->baseUrl; ?>/images/search.png"></td><td><a href="#">Відстежити статус заявки</a></td></tr>

</table>
</div>


<div id="leftecp">
<table width="70%"><tr><td width="0%"><img src="<?php echo Yii::app()->baseUrl; ?>/images/signature.png"></td><td width="100%"><a href="#">Як отримати ЕЦП?</a></td></tr></table>
</div>
</div></td></tr></table>







