<div id="classtitle">
<table>
<tr><td><span id="n0" style="background-color: #a2d507;"><a href="#" onclick="func(0)">ОРГАНІЗАЦІЯМ</a> </span></td>

<td><span id="n1"> <a href="#" onclick="func(1)">ГРОМАДЯНАМ</a></span></td>

</tr>
<tr><td><p  id="p0" style="background: url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top;"></p> </td><td><p  id="p1"></p> </td></tr></table>
</div>


<div id="servbg" class="container">
<div id="m0">
<?php $this->renderPartial('/serv/org'); ?>
</div>  
<div id="m1">
<?php $this->renderPartial('/serv/grom'); ?>
</div> 

</div>






