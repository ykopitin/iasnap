
<div id="shortblockserv">

<div id="shorttit">
<table>
<tr><td><span><?php echo GenServClasses::model()->findByPk($_GET['class'])->item_name;?></span></td></tr>
<tr><td><p style="height: 10px; background: url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top; margin-top: -2px;"></p> </td></tr></table>
</div>

<div id="shortblocktext">
<table>
	<tr>
		<td>
        
        <?php
        if ($_GET['class']=='1'){
        $this->renderPartial('/serv/grom');
        }
                if ($_GET['class']=='2'){
        $this->renderPartial('/serv/org');
        }
        ?>
        
        </td>
        <td style="border-bottom: 4px;"></td>
	</tr>
</table>
</div>

</div>