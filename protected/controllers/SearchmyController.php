<?php

class SearchmyController extends Controller
{
	public function actionIndex()
	{
	   if ($_GET['searchstr']=='' || $_GET['searchstr']=='Пошук по сайту') {$this->redirect(Yii::app()->user->returnUrl);}
   $search =  $_GET['searchstr']  ;

$q = preg_replace('/&([a-zA-Z0-9]+);/', ' ', $search);
//$q = utf8_strip_specials($q, ' ');
$q = trim(preg_replace('/ +/', ' ', $q));


define('CHAR_LENGTH', 2);
function stem($word){
   $a = rv($word);
   return $a[0].step4(step3(step2(step1($a[1]))));
}

function rv($word){
   $vowels = array('а','е','и','о','у','ы','э','ю','я');
   $flag = 0;
   $rv = $start='';
   for ($i=0; $i<strlen($word); $i+=CHAR_LENGTH){
      if ($flag == 1) $rv .= substr($word, $i, CHAR_LENGTH); else $start .= substr($word, $i, CHAR_LENGTH);
      if (array_search(substr($word,$i,CHAR_LENGTH), $vowels) !== FALSE) $flag = 1;
   }
   return array($start,$rv);
}

function step1($word){
   $perfective1 = array('в', 'вши', 'вшись');
   foreach ($perfective1 as $suffix) 
      if (substr($word, -(strlen($suffix))) == $suffix && (substr($word, -strlen($suffix) - CHAR_LENGTH, CHAR_LENGTH) == 'а' || substr($word, -strlen($suffix) - CHAR_LENGTH, CHAR_LENGTH) == 'я')) 
         return substr($word, 0, strlen($word)-strlen($suffix));
   $perfective2 = array('ив','ивши','ившись','ывши','ывшись');
   foreach ($perfective2 as $suffix) 
      if (substr($word, -(strlen($suffix))) == $suffix) 
         return substr($word, 0, strlen($word) - strlen($suffix));
   $reflexive = array('ся', 'сь');
   foreach ($reflexive as $suffix) 
      if (substr($word, -(strlen($suffix))) == $suffix) 
         $word = substr($word, 0, strlen($word) - strlen($suffix));
   $adjective = array('ее','ього','ій','ої','ое','ими','ыми','ей','ий','ый','ой','ем','им','ым','ом','его','ого','ему','ому','их','ых','ую','юю','ая','яя','ою','ею');
   $participle2 = array('ем','нн','вш','ющ','щ');
   $participle1 = array('ивш','ывш','ующ');
   foreach ($adjective as $suffix) if (substr($word, -(strlen($suffix))) == $suffix){
      $word = substr($word, 0, strlen($word) - strlen($suffix));
      foreach ($participle1 as $suffix) 
         if (substr($word, -(strlen($suffix))) == $suffix && (substr($word, -strlen($suffix) - CHAR_LENGTH, CHAR_LENGTH) == 'а' || substr($word, -strlen($suffix) - CHAR_LENGTH, CHAR_LENGTH) == 'я')) 
            $word = substr($word, 0, strlen($word) - strlen($suffix));
      foreach ($participle2 as $suffix) 
         if (substr($word, -(strlen($suffix))) == $suffix) 
            $word = substr($word, 0, strlen($word) - strlen($suffix));
      return $word;
   }
   $verb1 = array('ла','на','ете','йте','ли','й','л','ем','н','ло','но','ет','ют','ни','ть','ешь','нно');
   foreach ($verb1 as $suffix) 
      if (substr($word, -(strlen($suffix))) == $suffix && (substr($word, -strlen($suffix) - CHAR_LENGTH, CHAR_LENGTH) == 'а' || substr($word, -strlen($suffix) - CHAR_LENGTH, CHAR_LENGTH) == 'я')) 
         return substr($word, 0, strlen($word) - strlen($suffix));
   $verb2 = array('ила','ена','ена','ейте','уйте','ите','или','ыли','ей','уй','ил','ыл','им','ым','ен','ило','ыло','ено','ят','ует','уют','ит','ыт','ены','ить','ыть','ишь','ую','ю');
   foreach ($verb2 as $suffix) 
      if (substr($word, -(strlen($suffix))) == $suffix) 
         return substr($word, 0, strlen($word) - strlen($suffix));
   $noun = array('а','у','ів','ту','єв','ов','ння','є','е','іями','ями','ами','ьої','ії','и','ией','ей','ьої','і','є','иям','ям','ием','ем','ам','ом','о','у','ах','иях','ях','ы','ь','ию','ью','ю','ия','ья','я');
   foreach ($noun as $suffix) 
      if (substr($word, -(strlen($suffix))) == $suffix) 
         return substr($word, 0, strlen($word) - strlen($suffix));
   return $word;
} 

function step2($word){
   return substr($word, -CHAR_LENGTH, CHAR_LENGTH) == 'и' ? substr($word, 0, strlen($word) - CHAR_LENGTH) : $word;
}

function step3($word){
   $vowels = array('а','е','и','о','у','ы','э','ю','я');
   $flag = 0;
   $r1 = $r2 = '';
   for ($i=0; $i<strlen($word); $i+=CHAR_LENGTH){
      if ($flag==2) $r1 .= substr($word, $i, CHAR_LENGTH);
        if (array_search(substr($word, $i, CHAR_LENGTH), $vowels) !== FALSE) $flag = 1;
      if ($flag = 1 && array_search(substr($word, $i, CHAR_LENGTH), $vowels) === FALSE) $flag = 2;
   }
   $flag = 0;
   for ($i=0; $i<strlen($r1); $i+=CHAR_LENGTH){
      if ($flag == 2) $r2 .= substr($r1, $i, CHAR_LENGTH);
        if (array_search(substr($r1, $i, CHAR_LENGTH), $vowels) !== FALSE) $flag = 1;
        if ($flag = 1 && array_search(substr($r1, $i, CHAR_LENGTH), $vowels) === FALSE) $flag = 2;
    }
   $derivational = array('іст', 'ість');
   foreach ($derivational as $suffix) 
      if (substr($r2, -(strlen($suffix))) == $suffix) 
         $word = substr($word, 0, strlen($r2) - strlen($suffix));
   return $word;
}

function step4($word){
   if (substr($word, -CHAR_LENGTH * 2) == 'нн') $word = substr($word, 0, strlen($word) - CHAR_LENGTH);
   else {
      $superlative = array('ейш', 'ейше');
      foreach ($superlative as $suffix) 
         if (substr($word, -(strlen($suffix))) == $suffix) 
            $word = substr($word, 0, strlen($word) - strlen($suffix));
      if (substr($word, -CHAR_LENGTH * 2) == 'нн') $word = substr($word, 0, strlen($word) - CHAR_LENGTH);
   }
   if (substr($word, -CHAR_LENGTH, CHAR_LENGTH) == 'ь') $word = substr($word, 0, strlen($word) - CHAR_LENGTH);
   return $word;
}


$stopWords = array(
   'что', 'как', 'все', 'она', 'так', 'его', 'только', 'мне', 'было', 'вот',
   'меня', 'еще', 'нет', 'ему', 'теперь', 'когда', 'даже', 'вдруг', 'если',
   'уже', 'или', 'быть', 'был', 'него', 'вас', 'нибудь', 'опять', 'вам', 'ведь',
   'там', 'потом', 'себя', 'может', 'они', 'тут', 'где', 'есть', 'надо', 'ней',
   'для', 'тебя', 'чем', 'была', 'сам', 'чтоб', 'без', 'будто', 'чего', 'раз',
   'тоже', 'себе', 'под', 'будет', 'тогда', 'кто', 'этот', 'того', 'потому',
   'этого', 'какой', 'ним', 'этом', 'один', 'почти', 'мой', 'тем', 'чтобы',
   'нее', 'были', 'куда', 'зачем', 'всех', 'можно', 'при', 'два', 'другой',
   'хоть', 'после', 'над', 'больше', 'тот', 'через', 'эти', 'нас', 'про', 'них',
   'какая', 'много', 'разве', 'три', 'эту', 'моя', 'свою', 'этой', 'перед',
   'чуть', 'том', 'такой', 'более', 'всю'
);

$where = 'false';
$relevance = '0';
$count = 0;
$words = explode(' ', $q);

foreach($words as $w){
   if (in_array($w, $stopWords)) continue;
   if ($count++ > 4) break;
   $w = stem($w);
   $where .= ' name LIKE "%'.$w.'%"';
  // $relevance .= ' + ((LENGTH(name) -      LENGTH(REPLACE(name, "'.$w.'", ""))) / LENGTH("'.$w.'"))';
}
$relevance .= ' as relevance';
    
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
		//создаем criteria - запрос к базе данных
// условие получаем из GET запроса
$criteria = new CDbCriteria();
$criteria->condition = 'name like "%'.$w.'%"';
//$criteria->params = array (':name'=> $_GET['search']);
$criteria->order = 'name'; // сортируем по дате публикации


 $count=GenServices::model()->count($criteria);
 
    $pages=new CPagination($count);
    // элементов на страницу
    $pages->pageSize=10;
    $pages->applyLimit($criteria);
 
    $models = GenServices::model()->findAll($criteria);
 
    $this->render('index', array(
        'models' => $models,
        'pages' => $pages,


    ));


	}

	// Uncomment the following methods and override them if needed
	/*
	public function filters()
	{
		// return the filter configuration for this controller, e.g.:
		return array(
			'inlineFilterName',
			array(
				'class'=>'path.to.FilterClass',
				'propertyName'=>'propertyValue',
			),
		);
	}

	public function actions()
	{
		// return external action classes, e.g.:
		return array(
			'action1'=>'path.to.ActionClass',
			'action2'=>array(
				'class'=>'path.to.AnotherActionClass',
				'propertyName'=>'propertyValue',
			),
		);
	}
	*/
}