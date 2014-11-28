<div id="searchresult">
<h3>Ви шукали: <font color=red>"<?echo $_GET['searchstr'];?>"</font></h3>


<?php
//$newValue = rawurlencode($name);
$str=rawurlencode($_GET['searchstr']);
echo '<ul>';
foreach($models as $model)

{
 echo '<li><a href='.Yii::app()->baseUrl.'/index.php/service?searchstr='.$str.'&&param='.$model['id'].'>'.$model['name'].'</a></li>'; 
}

echo '<hr>';

$this->widget('CLinkPager', array(
    'pages' => $pages,
    'header' => 'Перейти до сторінки: ',
    	'firstPageLabel' => '<<',
'prevPageLabel' => '<',
'nextPageLabel' => '>',
'lastPageLabel' => '<<',
));

echo '</ul>';
if (!$models) {echo "Нажаль результатів немає. Спробуйте інший запит.";}

?>

</div>