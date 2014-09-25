<?php
/* @var $this SearchController */

$this->breadcrumbs=array(
	'Search',
);

function highlighter($keys, $source) {
        $t = explode(" ", $keys);
        foreach($t as $i)
        if(strlen($i) >= 2) $source = preg_replace('#' . $i . '#i', '<font color=black><i><b>$0</b></i></font>', $source);
 return $source;
}


$search=$_POST['searchstr'];
?>
<div id="searchresult">
<h3>Ви шукали: <font color=red>"<?echo $search;?>"</font></h3>
<?
echo '<ol>';
$rows=GenServices::model()->findAll("name like '%$search%'");
foreach($rows as $row){
    echo '<li><a href='.Yii::app()->baseUrl.'/index.php/service?param='.$row['id'].'>'.highlighter($search, $row['name']).'</a></li>';
}

//$rows=GenNews::model()->search($_POST['searchstr']);
$rows1=GenNews::model()->findAll("title like '%$search%' or text like '%$search%' or summary like '%$search%'");
foreach($rows1 as $row){
    echo '<li><a href='.Yii::app()->baseUrl.'/index.php/news?idn='.$row['id'].'>'.highlighter($search, $row['title']).'</a></li>';
}


echo '</ol>';
if (!$rows && !$rows1) {echo "Нажаль результатів немає. Спробуйте інший запрос.";}
?></div>