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


class SignController extends Controller
{
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
	  $cs = Yii::app()->clientScript;
      $cs->registerCoreScript('yiiactiveform');
		$model = new AuthForm;
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/js/jquery.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/auth/EUAuthMini.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerScriptFile(Yii::app()->baseUrl.'/auth/EUSignScripts3.js',CClientScript::POS_END);
//		Yii::app()->clientScript->registerCssFile(Yii::app()->baseUrl.'/auth/EUStyles2.css');
//var_dump($_POST);
		if(isset($_POST['Signature']))
		{
			$model->Signature = $_POST['Signature'];
//			$model->attributes=$_POST['AuthForm'];
			// validate user input and redirect to the previous page if valid
			if($model->validate() && $model->login())
//				$this->redirect(Yii::app()->user->returnUrl);
error_log("After authenticate, performing redirection");
				if(Yii::app()->user->checkAccess('siteadmin'))
					$this->redirect(Yii::app()->createUrl('admin'));
				else
					$this->redirect(Yii::app()->createUrl('cabinet'));
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



	public function actionRegister()
	{
      $cs = Yii::app()->clientScript;
      $cs->registerCoreScript('yiiactiveform');
		$model = new RegForm;
		if(isset($_POST['Signature']) && isset($_POST['Email']))
		{
			//$sig = new EUSignature($_POST['RegForm[Signature]']);
//			$model->attributes=$_POST['regform'];
//print_r($_POST);

//Yii::app()->end();
			$model->Signature = $_POST['Signature'];
			$model->Email = $_POST['Email'];
			$model->Email2 = $_POST['Email2'];
			$model->Phone = $_POST['Phone'];
			$model->Acceptance = $_POST['Acceptance'];
			$model->TypeOfUser = $_POST['TypeOfUser'];
			
			// if it is ajax validation request
			if(isset($_POST['ajax']) && $_POST['ajax']==='reg-form')
			{
				echo CActiveForm::validate($model);
				Yii::app()->end();
			}
//			$model->Email = $_POST['RegForm[Email]'];
//			$model->Email2 = $_POST['RegForm[Email2]'];
//			$model->Phone = $_POST['RegForm[Phone]'];
//			$model->ConfirmPersonalData = $_POST['RegForm[Email]'];
error_log("reg001");
			if($model->validate()){
				$user_activation_code = "none";
				if($model->verify_sign()) {
//error_log("reg002");
					if ($model->Email != $model->Email2) {$this->addError('Email', 'Введені адреси електронної пошти не співпадають'); return false;}
					$existing_cert = CabUserExternCerts::model()->findByAttributes(array('certissuer'=>$model->SigData->sIssuer, 'certserial'=>$model->SigData->sSerial));
					if(!($existing_cert===null)){	// There is same certificate already exists, we cannot allow to register current user
						$model->addError('Email', 'Користувач, зареєстрований з Вашим сертифікатом вже існує на Порталі. Якщо Ви раніше реєструвалися на Порталі, виконайте вхід за ЕЦП (авторизацію). Якщо ні - зверніться до онлайн-консультанта або за гарячою лінією (048) 705-45-74.');
						Yii::app()->clientScript->corePackages = array();
						$this->render('register', array('model'=>$model, 'errors'=>$model->getErrors()));
						return false;
					}
//	Now we allow only 1 org user with 1 dir cert and 1 org cert (pechatka)
					if ($model->TypeOfUser == 1) {
						$existing_cert = CabUserExternCerts::model()->findByAttributes(array('certissuer'=>$model->SigDataOrg->sIssuer, 'certserial'=>$model->SigDataOrg->sSerial));
						if(!($existing_cert===null)){	// There is same certificate already exists, we cannot allow to register current user
							$model->addError('Email', 'Організація, зареєстрована з Вашим сертифікатом вже існує на Порталі. Якщо Ви раніше реєструвалися на Порталі, виконайте вхід за ЕЦП (авторизацію). Якщо ні - зверніться до онлайн-консультанта або за гарячою лінією (048) 705-45-74.');
							Yii::app()->clientScript->corePackages = array();
							$this->render('register', array('model'=>$model, 'errors'=>$model->getErrors()));
							return false;
						}
					}
					$user_model = new CabUser();
//error_log("reg003");
					$user_model->email = $model->Email;
					$user_model->phone = $model->Phone;

					$user_model->type_of_user = $model->TypeOfUser;
					$user_model->cab_state = "не активований";
					$user_model->authorities_id = 1;
					$user_model->user_roles_id = 4;
					$user_activation_code = randomText(40,'string','int');
					$user_model->str_activcode = $user_activation_code;
					$user_model->time_activcode = time() + 7*24*60*60; // Allow 7 days to activate account (604800 seconds)
					$user_model->pd_agreement_signed = $model->Signature;
					$user_model->time_registered = time();
//error_log("reg004");
					if($user_model->validate()){
						$user_model->save();
					}else{
//	Need to be fixed
						$model->addError('Acceptance', 'Виникла помилка при реєстрації облікового запису.');
						$this->render('register', array('model'=>$model, 'errors'=>$model->getErrors()));
//						print_r($user_model->getErrors());
						Yii::app()->end();
					}
//error_log("reg005 After user_model save");
					$user_model_cert = new CabUserExternCerts();
					$user_model_cert->type_of_user = 0; //$user_model->type_of_user;
					$user_model_cert->certissuer = $model->SigData->sIssuer;
					$user_model_cert->certserial = $model->SigData->sSerial;
					$user_model_cert->certSubjDRFOCode = $model->SigData->sSubjDRFOCode;
					$user_model_cert->certSubjEDRPOUCode = $model->SigData->sSubjEDRPOUCode;
					$user_model_cert->certType = 0;
					$user_model_cert->certData = base64_decode($model->CertSign);
//error_log("reg006 CertSign:".$user_model_cert->certData);
					$user_model_cert->ext_user_id = $user_model->id;
					
// Need to converto to Timestamp					$user_model_cert->certSignTime = $model->SigData->sSignTime
					if ($model->SigData->bUseTSP == true)
						$user_model_cert->certUseTSP = 1; // need to be tested, first is integer, second is bool
					else $user_model_cert->certUseTSP = 0;
					$user_model_cert->certIssuerCN = $model->SigData->sIssuerCN;
					$user_model_cert->certSubject = $model->SigData->sSubject;
					$user_model_cert->certSubjCN = $model->SigData->sSubjCN;
					$user_model_cert->certSubjOrg = $model->SigData->sSubjOrg;
					$user_model_cert->certSubjOrgUnit = $model->SigData->sSubjOrgUnit;
					$user_model_cert->certSubjTitle = $model->SigData->sSubjTitle;
					$user_model_cert->certSubjState = $model->SigData->sSubjState;
					$user_model_cert->certSubjLocality = $model->SigData->sSubjLocality;
					$user_model_cert->certSubjFullName = $model->SigData->sSubjFullName;
					$user_model_cert->certSubjAddress = $model->SigData->sSubjAddress;
					$user_model_cert->certSubjPhone = $model->SigData->sSubjPhone;
					$user_model_cert->certSubjEMail = $model->SigData->sSubjEMail;
					$user_model_cert->certSubjDNS = $model->SigData->sSubjDNS;
					
					$user_model_cert->certExpireBeginTime = $model->CertExpireBeginTime;
					$user_model_cert->certExpireEndTime = $model->CertExpireEndTime;
					
					$user_model_cert_org = "";
					
					if ($model->TypeOfUser == 1) {
						$user_model_cert_org = new CabUserExternCerts();
						$user_model_cert_org->type_of_user = 1;
						$user_model_cert_org->certissuer = $model->SigDataOrg->sIssuer;
						$user_model_cert_org->certserial = $model->SigDataOrg->sSerial;
						$user_model_cert_org->certSubjDRFOCode = $model->SigDataOrg->sSubjDRFOCode;
						$user_model_cert_org->certSubjEDRPOUCode = $model->SigDataOrg->sSubjEDRPOUCode;
						$user_model_cert_org->certType = 0;
						$user_model_cert_org->certData = base64_decode($model->CertSignOrg);
//error_log("reg006 CertSign:".$user_model_cert->certData);
						$user_model_cert_org->ext_user_id = $user_model->id;
					
// Need to converto to Timestamp					$user_model_cert->certSignTime = $model->SigData->sSignTime
						if ($model->SigDataOrg->bUseTSP == true)
							$user_model_cert_org->certUseTSP = 1; // need to be tested, first is integer, second is bool
						else $user_model_cert_org->certUseTSP = 0;
						$user_model_cert_org->certIssuerCN = $model->SigDataOrg->sIssuerCN;
						$user_model_cert_org->certSubject = $model->SigDataOrg->sSubject;
						$user_model_cert_org->certSubjCN = $model->SigDataOrg->sSubjCN;
						$user_model_cert_org->certSubjOrg = $model->SigDataOrg->sSubjOrg;
						$user_model_cert_org->certSubjOrgUnit = $model->SigDataOrg->sSubjOrgUnit;
						$user_model_cert_org->certSubjTitle = $model->SigDataOrg->sSubjTitle;
						$user_model_cert_org->certSubjState = $model->SigDataOrg->sSubjState;
						$user_model_cert_org->certSubjLocality = $model->SigDataOrg->sSubjLocality;
						$user_model_cert_org->certSubjFullName = $model->SigDataOrg->sSubjFullName;
						$user_model_cert_org->certSubjAddress = $model->SigDataOrg->sSubjAddress;
						$user_model_cert_org->certSubjPhone = $model->SigDataOrg->sSubjPhone;
						$user_model_cert_org->certSubjEMail = $model->SigDataOrg->sSubjEMail;
						$user_model_cert_org->certSubjDNS = $model->SigDataOrg->sSubjDNS;
					
						$user_model_cert_org->certExpireBeginTime = $model->CertOrgExpireBeginTime;
						$user_model_cert_org->certExpireEndTime = $model->CertOrgExpireEndTime;
						if(!$user_model_cert_org->validate()) {
// Deleting corresponding user, that was not completely registered with certificates
							$user_model->delete();
							$model->addError('Acceptance', 'Виникла помилка при реєстрації юридичної особи.');
							$this->render('register', array('model'=>$model, 'errors'=>$model->getErrors()));
//							print_r($user_model_cert->getErrors());
							Yii::app()->end();
						}
					}
					
//error_log("reg007");
					if($user_model_cert->validate()){
						if ($user_model->type_of_user == 1) {
							$user_model->fio = $model->SigDataOrg->sSubjCN;
						} else
							$user_model->fio = $model->SigData->sSubjCN;
						$user_model->save();
						$user_model_cert->save();
						if ($user_model->type_of_user == 1)
							$user_model_cert_org->save();
// Sending email to new user via extension SwiftMailer
						// Plain text content
						$plainTextContent = "Ви отримали це повідомлення, тому що на порталі Центру надання адміністративних послуг http://allium2.soborka.net/iasnap (далі - ЦНАП) ";
						$plainTextContent .= "була розпочата процедура реєстрації з використанням цієї електронної поштової скриньки.\n";
						$plainTextContent .= "Якщо Ви бажаєте завершити реєстрацію та мати можливість здійснювати вхід до власного кабінету на порталі ЦНАП, ";
						$plainTextContent .= "Вам необхідно підтвердити володіння цією електронною поштовою скринькою шляхом переходу за наступним посиланням:\n";
						$plainTextContent .= Yii::app()->createAbsoluteUrl('sign/regconfirm')."/?activationcode=".$user_activation_code."\n";
						$plainTextContent .= "Це повідомлення згенеровано автоматично.";
						
						$richTextContent = "<p>Ви отримали це повідомлення, тому що на порталі Центру надання адміністративних послуг http://allium2.soborka.net/iasnap (далі - ЦНАП) ";
						$richTextContent .= "була розпочата процедура реєстрації з використанням цієї електронної поштової скриньки.</p>";
						$richTextContent .= "<p>Якщо Ви бажаєте завершити реєстрацію та мати можливість здійснювати вхід до власного кабінету на порталі ЦНАП, ";
						$richTextContent .= "Вам необхідно підтвердити володіння цією електронною поштовою скринькою шляхом переходу за наступним посиланням:</p>";
						$richTextContent .= '<a href="'.Yii::app()->createAbsoluteUrl('sign/regconfirm')."/?activationcode=".$user_activation_code.'">'.Yii::app()->createAbsoluteUrl('sign/regconfirm')."/?activationcode=".$user_activation_code.'</a><br>';
						$richTextContent .= "Це повідомлення згенеровано автоматично.";
						// Get mailer
						$SM = Yii::app()->swiftMailer;
						// Get config
						$mailHost = '127.0.0.1';
						$mailPort = 25; // Optional
						// New transport
						$Transport = $SM->smtpTransport($mailHost, $mailPort);
						// Mailer
						$Mailer = $SM->mailer($Transport);
						// New message
						$Message = $SM
							->newMessage('Портал Центру надання адміністративних послуг')
							->setFrom(array('cnap@cnaptest.pp.ua' => 'Портал Центру надання адміністративних послуг'))
							->setTo(array($user_model->email => $model->SigData->sSubjCN))
							->addPart($richTextContent, 'text/html')
							->setBody($plainTextContent);
						// Finally, send mail
						$result = $Mailer->send($Message);							
					}else{
// Deleting corresponding user, that was not completely registered with certificates
						$user_model->delete();
						print_r($user_model_cert->getErrors());
						Yii::app()->end();
					}
error_log("reg008");
					//$this->redirect(Yii::app()->createUrl('sign/registerdone'));
					
					$this->render('regconfirm', array('model'=>$user_model));
				}
			}
			
//var_dump($model->validate());
			// validate user input and redirect to the previous page if valid
//			if($model->validate() && $model->register())
//				$this->redirect(Yii::app()->user->returnUrl);
//				$this->redirect(Yii::app()->baseUrl.'/auth/regconfirm');
			if($model->validate() && $model->verify_sign())
//				$this->render('regconfirm');
//				$this->redirect(Yii::app()->createUrl('auth/regconfirm'));
				Yii::app()->end();
		}
		Yii::app()->clientScript->corePackages = array();
		$this->render('register', array('model'=>$model, 'errors'=>$model->getErrors()));

	}



	public function actionRegconfirm() {
		$model = new AuthForm;
		if(isset($_POST['AuthForm']))
		{
			$sig = new EUSignature($_POST['AuthForm']['Signature']);
			$er = $sig->check();
			if ($er == 0){
				echo $sig->sResultData;
				echo "<input type='text' value='".$sig->sSubjCN."' /><br>";
				echo "<input type='text' value='".$sig->sSubjFullName."' />";
			} else { echo "Помилка при перевірці підпису"; }
		}
		$this->render('regconfirm', array('model'=>$model));
	}

	public function actionSignform() {
		$model = new AuthForm;
		if(isset($_POST['Signform']))
		{
			$sig = new EUSignature($_POST['Signform']);
			$er = $sig->check();
			if ($er == 0){
				echo $sig->sResultData;
				Yii::app()->end;
			}
		}
		$this->render('signform', array('model'=>$model));
	}
	
	public function actionUserid() {
		echo Yii::app()->user->id;
		echo "<br>";
		$auth = Yii::app()->authManager;
		var_dump($auth->getRoles(Yii::app()->user->id));
	}
	
	public function actionTest() {
		echo Yii::app()->user->checkAccess('siteadmin');
	}

	
	public function actionRegister2()
	{
      $cs = Yii::app()->clientScript;
      $cs->registerCoreScript('yiiactiveform');
	  $countFreeIntUsers = CabUser::model()->count(new CDbCriteria(array
		(
			'condition' => 'user_roles_id < 4 and cab_state = "не активований"' //Пошук неактивованих внутрішніх користувачів
//			'params' => array(':people_id'=>$people->id)
		)));
		if ($countFreeIntUsers < 1) {	// Немає необхідності подавати запити на реєстрацію з кодом активації
//			$this->render('regrequestconfirm', array('model'=>'deny'));
			throw new CHttpException(404,'Системі не вдалося знайти запитувану дію "register2".');
//			Yii::app()->end;
		}
		$model = new RegrequestForm;
		if(isset($_POST['Signature']))
		{
			$model->Signature = $_POST['Signature'];
			if ($model->verify_sign()) {
				$user_model_cert = new CabUserInternCerts();
				$user_model_cert->certissuer = $model->SigData->sIssuer;
				$user_model_cert->certserial = $model->SigData->sSerial;
				$user_model_cert->certSubjDRFOCode = $model->SigData->sSubjDRFOCode;
				$user_model_cert->certSubjEDRPOUCode = $model->SigData->sSubjEDRPOUCode;
				$user_model_cert->certType = 0;
				$user_model_cert->certData = base64_decode($model->CertSign);
				$user_model_cert->signedData = $model->activ_code;
				if($user_model_cert->validate()){
					$user_model_cert->save();
					$this->render('regrequestconfirm', array('model'=>'allow'));
				}else{
					print_r($user_model_cert->getErrors());
					Yii::app()->end();
				}				
			}
			
		}
		$this->render('regrequest', array('model'=>$model));
	}
	

	public function actionCreateRBAC(){
		$auth=Yii::app()->authManager;
//user_roles_id:
//	0	secadmin
//	1	siteadmin
//	2	cnapadmin
//	3	snapoperator
//	4	customer
//	5	guest
		$auth->createRole('secadmin');
		$auth->createRole('siteadmin');
		$auth->createRole('cnapadmin');
		$auth->createRole('snapoperator');
		$auth->createRole('customer');
		$auth->createRole('guest');

		$users = CabUser::model()->findAll();
		foreach($users as $u) {
			error_log("u role:".$u->id." rol:".$u->user_roles_id);
			if ($u->user_roles_id < 2)
				$auth->assign('siteadmin', $u->id);
			if ($u->user_roles_id == 0)
				$auth->assign('secadmin', $u->id);
			if ($u->user_roles_id == 2)
				$auth->assign('cnapadmin', $u->id);
			if ($u->user_roles_id == 3)
				$auth->assign('snapoperator', $u->id);
			if ($u->user_roles_id == 4)
				$auth->assign('customer', $u->id);
		}

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
