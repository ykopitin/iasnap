<div id="onl">
<?php
 if (GenServices::model()->findByPk($_GET['param'])->is_online=='так')
{
?>
<table><tr><td><div id="otonline"><a href="#">ОТРИМАТИ ПОСЛУГУ ></a></div></td></tr></table>
<?php
}
?><div id="shortblock">

<table>
	<tr>
		<td id="first"><h3>Державний орган</h3><?php echo GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjwork_id)->name;?></td>
	</tr>

<?php if (isset($_GET['class'])) {?>
	<tr>
		<td><h3>Отримувач</h3><?php if ($_GET['class']=='1'){echo "Громадяни";} if ($_GET['class']=='2'){echo "Організації";}?></td>
	</tr>
<?php }?>

	<tr>
		<td><h3>Місце надання послуги</h3><?php echo GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->name;?></td>
	</tr>
	<tr>
		<td><h3>Вартість послуги</h3><?php if (GenServices::model()->findByPk($_GET['param'])->is_payed=='1'){echo "Платно";} if (GenServices::model()->findByPk($_GET['param'])->is_payed=='0'){echo "Безоплатно";}?></td>
	</tr>
	<tr>
		<td style="border-bottom:0"><h3>Строк надання</h3><?php echo GenServices::model()->findByPk($_GET['param'])->deadline;?></td>
	</tr>
</table>


</div>

</div>

