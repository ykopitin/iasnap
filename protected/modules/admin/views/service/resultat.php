<?
echo '<p><b><font size=3 color=black>Результат надання послуги:</font></b></p>';
echo '<p>'.GenServices::model()->findByPk($_GET['param'])->result.'</p>';
?>