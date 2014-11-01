<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="language" content="en" />
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/main.css" />
</head>
<body>



 <?php
 
 echo '<div id="posnamebg"><div id=posname>'.GenServices::model()->findByPk($_GET['param'])->name.'</div></div>';
 
 echo "<div id=printarea>";
 echo '<h1>Опис послуги</h1>';
  echo '<h3>Нормативно правові акти, що регламентують надання послуги</h3>';
  echo GenServices::model()->findByPk($_GET['param'])->regulations;
  echo '<h3>Порядок та спосіб подання документів, необхідних для отримання адміністративної послуги</h3>';
  echo GenServices::model()->findByPk($_GET['param'])->submission_proc;
  echo '<h3>Перелік підстав для відмови у наданні адміністративної послуги</h3>';
  echo GenServices::model()->findByPk($_GET['param'])->denail_grounds;
  echo '<h3>Способи отримання відповіді (результату)</h3>';
  echo GenServices::model()->findByPk($_GET['param'])->answer;
  echo '<h3>Результат надання послуги</h3>';
  echo GenServices::model()->findByPk($_GET['param'])->result;
 
  echo '<h1>Документи</h1>';
  echo '<h3>Перелік документів, необхідних для отримання адміністративної послуги</h3>';
  echo GenServices::model()->findByPk($_GET['param'])->docums;
 
 
 echo '<h1>Місця звернення</h1>';
  echo '<h3>'.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->name.'</h3>';
  echo '<b>Адреса:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->street.', '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->building.'<br>';

 echo '<b>Режим роботи:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->working_time.'<br>';

 echo '<b>E-mail:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->email.'<br>';

echo '<b>Веб-сайт:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->web.'<br>';

echo '<b>Телефон:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->phone.'<br>';

echo '<b>Факс:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->fax.'<br>';
 

if (GenServices::model()->findByPk($_GET['param'])->is_payed==1){

   echo  '<h1>Платність (безоплатність) надання адміністративної послуги</h1>';
   echo '<h3>Платно</h3>';
   echo '<h3>Нормативно-правові акти, на підставі яких стягується плата</h3>';
   echo GenServices::model()->findByPk($_GET['param'])->payed_regulations;
   echo '<h3>Розмір та порядок внесення плати (адміністративного збору) за платну адміністративну послугу</h3>';
   echo GenServices::model()->findByPk($_GET['param'])->payed_rate;
    echo '<h3>Розрахунковий рахунок для внесення плати</h3>';
    echo GenServices::model()->findByPk($_GET['param'])->bank_info;

}
else
{
  
    echo     '<h1>Платність (безоплатність) надання адміністративної послуги</h1>';
    echo '<h3>Безоплатно</h3>';
     
}

 echo '<br>';
 
 ?>
</div>
 </body>
</html>