<div id='news'>

<table width="100%">
	<tr>
		<td colspan="3"><h3>Новини порталу</h3></td>
	</tr>
	<tr>
<?php $rows=GenNews::model()->lastnews();
foreach($rows as $row) {
     echo '<td width=33% valign=top><table>';   
	echo '<tr><td ><font face="arial sans-serif" color=#16bae9 size=4>'.Yii::app()->dateFormatter->format("dd MMMM yyyy", $row['publicationDate']).'</font></td></tr>';
    	echo '<td><a href='.Yii::app()->request->baseUrl.'/index.php/news?idn='.$row['id'].'>'.$row['title'].'</a></td></tr>';
        	echo '<td><font color=#808080>'.$row['summary'].'</font></td></tr>';    
     	 echo '</table></td>';
                    }
?>
</tr>
</table>


</div>