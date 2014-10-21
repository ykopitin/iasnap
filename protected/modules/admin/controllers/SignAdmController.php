<?php
function randomText()
{
    //Получаем аргументы
    $args_ar = func_get_args();
    $new_arr = array();
 
    //Определяем длину текста
    $length = $args_ar[0];
    unset($args_ar[0]);
 
    if(!sizeof($args_ar))
    {
        $args_ar = array("string","int","symbol");
    }
 
    $arr['string'] = array(
         'a','b','c','d','e','f',
         'g','h','i','j','k','l',
         'm','n','o','p','r','s',
         't','u','v','x','y','z',
         'A','B','C','D','E','F',
         'G','H','I','J','K','L',
         'M','N','O','P','R','S',
         'T','U','V','X','Y','Z');
 
    $arr['int'] = array(
         '1','2','3','4','5','6',
         '7','8','9','0');
 
    $arr['symbol'] = array(
         '.','$','[',']','!','@',
         '*', '+','-','{','}');
 
    //Создаем массив из всех массивов
    foreach($args_ar as $type)
    {
        if(isset($arr[$type]))
        {
            $new_arr = array_merge($new_arr,$arr[$type]);
        }
    }
 
    // Генерируем строку
    $str = "";
    for($i = 0; $i < $length; $i++)
    {
        // Вычисляем случайный индекс массива
        $index = rand(0, count($new_arr) - 1);
        $str .= $new_arr[$index];
    }
    return $str;
}


class SignAdmController extends Controller
{

        /**
         * @var string the default layout for the views. Defaults to '//layouts/column2', meaning
         * using two-column layout. See 'protected/views/layouts/column2.php'.
         */
        public $layout='//layouts/column1';

	public function actionGetString()
	{
	        $input = Yii::app()->request->getPost('ask');
		error_log("log:".$input);
		if (base64_decode($input, true) == "GenerateAuthString")
		{
			GenStr::model()->deleteAll("itime < :itime", array('itime' => time()-120));
//			var_dump($timed_out_records);
//			foreach ($timed_out_records as $result){
//				error_log($result->itime);
//			}
			if(Yii::app()->request->isAjaxRequest){
			        $randstr = randomText(40,'string','int','symbol');
				$sauth_record=new GenStr;
				$sauth_record->sauth=$randstr;
				$sauth_record->itime=time();
				$sauth_record->save();
				$arr = array('randstr' => $randstr);
				echo json_encode($arr);
			        Yii::app()->end();
			}
		}
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/js/jquery.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/auth/EUAuth.js',CClientScript::POS_END);
//		$this->render('index');
	}

	public function actionIndex()
	{
		$model = new AuthForm;
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/js/jquery.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/auth/EUAuthMini.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/auth/EUSignScripts3.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerCssFile(Yii::app()->baseUrl.'/auth/EUStyles2.css');
		$this->render('index', array('model'=>$model));
	}

	public function actionLogin()
	{
		$model = new AuthForm;
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/js/jquery.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/auth/EUAuthMini.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/auth/EUSignScripts3.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerCssFile(Yii::app()->baseUrl.'/auth/EUStyles2.css');
//var_dump($_POST);
		if(isset($_POST['AuthForm']))
		{
			$model->attributes=$_POST['AuthForm'];
			// validate user input and redirect to the previous page if valid
			if($model->validate() && $model->login())
//				$this->redirect(Yii::app()->user->returnUrl);
				$this->redirect(Yii::app()->baseUrl);
		}
		$this->render('index', array('model'=>$model));
	}

        public function actionLogout()
        {
                Yii::app()->user->logout();
                $this->redirect(Yii::app()->homeUrl);
        }


	public function actionGetCertificates()
	{
		$certdir = Yii::app()->basePath."/../certificates";
error_log($certdir);
//		$certdir = "../../certificates";
		$file_list = scandir($certdir);
		$file_list2 = array();
error_log("getcertificates 1");
//		$i=0;
		foreach ($file_list as $file_name)
		{
			if (is_file($certdir."/".$file_name) && (substr($file_name, -4)==".cer"))
			{
error_log("getcertificates 2");
				$file_content=file_get_contents($certdir."/".$file_name);
//				$file_content="0934287509384j5f234jf5";
				$file_list2[$file_name] = base64_encode($file_content);
//				$file_list2[$i++] = $file_content;
			}
		}
error_log("getcertificates 3");
		echo json_encode($file_list2);
//		return $file_list2;
	}

	
	public function actionUserid() {
		echo Yii::app()->user->id;
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
