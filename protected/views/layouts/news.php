<div id='news'>

<table width="100%">
	<tr>
		<td colspan="3"><h3>Новини порталу</h3><div id="archnews"><a href="/news/?idn=all#anchor1">Архів новин</a></div></td>
	</tr>
   
	<tr>
<?php $rows=GenNews::model()->lastnews();
foreach($rows as $row) {
    echo '<td width=33% valign=top><table>';   
	echo '<tr><td><font face="arial" sans-serif color=#076c8e size=3>'.Yii::app()->dateFormatter->format("dd MMMM yyyy", $row['publicationDate']).'</font></td></tr>';
    echo '<tr><td><img src=/images/news/'.GenNews::model()->findByPk($row['id'])->img.' style="height: 100px;"></td></tr>';
    echo '<tr><td><a href='.Yii::app()->request->baseUrl.'/index.php/news?idn='.$row['id'].'>'.$row['title'].'</a></td></tr>';
    echo '<td><font color=#808080><p align="justify">'.$row['summary'].'</p></font></td></tr></table></td>';    
    
                    }
?>
<td>
<?php 
include 'Fpoll/poll.php';
?>

</td></tr>
</table>


</div>


