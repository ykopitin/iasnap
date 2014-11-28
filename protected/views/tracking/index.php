<div id="pagetit">Відстеження стану заявки</div>

 <form action="/tracking" method="GET"><div id="trackinput">
           <table>
           <tr><td>Для отримання інформації щодо стану заявки на отримання послуги введіть трек-номер, що зазначений на Квітку-описі, який Вам надав адміністратор ЦНАП:<br><br> <input type="text" name="tracksts" id="searchin"  size="50">
           
           
           
          <input type="image"  id="searchim" style="border: none;" src="/images/search-btn.png" onClick=submit() id="searchbtn"/ >
           
           
           
           </td></tr>
<tr><td><font color=#797979 size=1>Наприклад: 482000012345</font></td></tr>
          </table> 
		</div>	</form>

<div id="tracksearch">

<?php
if (isset($_GET['tracksts']))
{
Yii::import("mff.components.utils.tracknumberUtil");
if (tracknumberUtil::checkTracknumber($_GET['tracksts'])=='true' && isset(FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->id)) {

echo '<hr>&nbsp;Ви шукали заявку з трек-номером:<font color=black><b> '.$_GET['tracksts'].'</b></font><br><br>';
echo '<table>';

//<a href='.Yii::app()->baseUrl.'/index.php/service?searchstr='.$str.'&&param='.$model['id'].'>'.$model['name'].'</a>


echo '<tr><td><font color=black>Найменування&nbsp;послуги:&nbsp;</font></td><td><a href=#>'.GenServices::model()->findByPk(FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->service)->name.'</a></td></tr>';
echo '<tr><td><font color=black>Дата подачі заявки: </font></td><td>'.Yii::app()->dateFormatter->format("dd MMMM yyyy", FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->createdate).'</td></tr>';



if (FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->authorities!='') 
{
echo '<tr><td><font color=black>Виконавець: </font></td><td>'.GenAuthorities::model()->findByPk(FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->authorities)->name.'</td></tr>';
}


echo '<tr><td><font color=black>Стан заявки: </font></td><td>';


if (FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->reply=='') echo "<font color=#076c8e><b>Прийнято в роботу</b></font></td></tr>";
if (FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->reply==91) echo "<font color=red><b>Відмовлено</b></font></td></tr>";
if (FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->reply==92) echo "<font color=#076c8e><b>Прийняте рішення</b></font></td></tr>";
if (FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->reply==93) echo "<font color=#076c8e><b>Видано дозвільний документ</b></font></td></tr>";

if (FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->plandate!='') 
{
echo '<tr><td><font color=black>Дата обробки: </font></td><td>'.Yii::app()->dateFormatter->format("dd MMMM yyyy", FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->plandate).'</td></tr>';
}



//$tracknumber=tracknumberUtil::getTracknumberFromId($id);   482000020851
//$id = tracknumberUtil::getIdFromTracknumber($tracknumber); - получение ID из трэкномера
//$boolean =  tracknumberUtil::checkTracknumber($tracknumber); - проверка правильности трэкномера

if (FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->reason=='') 
{
echo '<tr><td><font color=black>Додаткова інформація: </font></td><td>відсутня.</td></tr>';
}
else
{
echo '<tr><td><font color=black>Додаткова інформація: </font></td><td>'.FfDocumentCnap::model()->findByPK(tracknumberUtil::getIdFromTracknumber($_GET['tracksts']))->reason.'</td></tr>';

}
echo '</table>';

}
else {
echo "<font color=red><b>&nbsp;Введіть вірний трек-номер!</b></font>";
}

}

?>
</div>