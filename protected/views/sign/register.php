<?php
/* @var $this AuthController */
/* @var $model RegForm */
/* @var $form CActiveForm  */

$this->breadcrumbs=array(
	'Auth',
);
?>

<style>
input[type=submit].eusign {
	width: 270px;
	height: 44px;
	border-radius: 5px;
	background-color: #a2d507;
}
input[type=button].eusign {
	width: 270px;
	height: 44px;
	border-radius: 5px;
}
input[type=checkbox].eusign {
	color: #000000;
}
</style>
<style>
    .btn-primary {
        margin-right: 10px;
    }
	
	input.edit {
		width: 270px;
		height: 30px;
		border-radius: 5px;
		margin-bottom: 4px;
	}
	div.ui-dialog {
		border-radius: 5px;
	}
	div.ui-widget-header {
		background: #a2d507 url(<?php echo Yii::app()->baseUrl.'/images/ui-bg_highlight-soft_75_a2d507_1x100.png'; ?>) 50% 50% repeat-x;
	}
	
	.container {
		width: 100%;
	}
	
	.errorMessage {
		width: 270px;
		text-align: justify;
	}
</style>
<style>
.hidescreen,
.load_page {
 position: fixed;
 display: none; /*изначально блоки скрыты*/
}
.hidescreen {
 z-index: 9998;
 width: 100%;
 height: 100%;
 background: #000000;
 opacity: 0.9;
 filter: alpha(opacity=70);
 left:0;
 top:0;
}
.load_page {
 z-index: 9999; /*значение должно больше чем для .hidescreen*/
 left: 50%;
 top: 50%;
 padding: 30px 10px;
 text-align: center;
 color: white;
 font: normal normal 15px Verdana;
 border: none;
 margin-left: -125px;
 width: 250px;
}
</style>
<style>
.person-type {
	width: 130px;
	display: inline-block;
	padding: 15px 0;
	text-align: center;
	text-decoration: none;
	color: #717171;
	font-size: 14px;
	background: #f3f3f3;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.7);
	-moz-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.7);
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.7);
}
.person-type.active {
	color: #000;
	background-color: #a2d507;
}
</style>


<div id="div_loading" class='load_page'>
<p></p>
 <?php 
	if (file_exists(Yii::getPathOfAlias('webroot') . '/images/loading.gif')) {
		echo CHtml::image(Yii::app()->baseUrl . '/images/loading.gif');
	};
?>
 <br>
 <b>Зачекайте</b>
</div>
<div id="div_hidescreen" class='hidescreen'></div>

<?php
$this->beginWidget('zii.widgets.jui.CJuiDialog', array(
    'id' => 'proxy_window',
    'options' => array(
        'title' => 'Налаштування доступу до мережі',
        'autoOpen' => false,
        'modal' => true,
        'resizable' => false,
        'width' => '50%',
        'overlay' => array(
            'backgroundColor' => '#000',
            'opacity' => '8.5'
        ),
    ),
));
?>

<div id="proxy_div" style="display: none;">
    <div>
        Якщо вихід до Інтернету здійснюється за допомогою проксі-сервера, необхідно вказати параметри підключення до
        нього
        <i class="help-pop sprite sprite-info"
           data-content="Зверніться до адміністратора мережі або у ІТ відділ за параметрами проксі-сервера">i</i>
    </div>
    <br>

    <div style="width: 100%">
        <label style="display: block;"><input id="ProxyUse" type="checkbox" onclick="Use_Proxy_Check()"
                                              style="vertical-align: text-bottom; position: relative; top: -1px;"/>Використовувати
            проксі-сервер</label>

        <div id="proxy-settings" style="display: none;">
            <input class="edit" id="ProxyName" type="text" value="" placeholder="Адреса проксі-сервера"/>
			<br>
            <input class="edit" id="ProxyPort" type="text" value="" placeholder="Порт проксі-сервера"/>
			<br>

            <div>
                <label><input id="ProxyAnonymous" type="checkbox" onclick="Use_Proxypas_Check()"
                              style="vertical-align: text-bottom; position: relative; top: -1px;"/>Авторизація на
                    проксі-сервері</label>
            </div>
            <div id="proxy-auth" style="display: none;">
                <input class="edit" id="ProxyUser" type="text" value="" placeholder="Ім'я користувача"/>
				<br>
                <input class="edit" id="ProxyPass" type="password" value="" placeholder="Пароль"/>
				<br>
                <input id="OwnCertPath" type="hidden" value=""/><br>
            </div>
        </div>
    </div><br>
    <div style="width: 100%; text-align: center;">
        <input type="button" style="width: 35%;" value="Зберегти налаштування"
               onclick="proxy_window_SetProxy(); $('#proxy_window').dialog('close');"/>
        <input type="button" style="width: 35%;" value="Відмінити та закрити вікно"
               onclick="proxy_window_GetProxy(); $('#proxy_window').dialog('close');"/>
    </div>
</div>
<?php
$this->endWidget('zii.widgets.jui.CJuiDialog');
?>

<div id="div_loading" class='load_page'>
<p></p>
 <?php 
	if (file_exists(Yii::getPathOfAlias('webroot') . '/images/loading.gif')) {
		echo CHtml::image(Yii::app()->baseUrl . '/images/loading.gif');
	};
?>
 <br>
 <b>Зачекайте</b>
</div>
<div id="div_hidescreen" class='hidescreen'></div>

<table width="900px"><tr><td width="650px" style="vertical-align: top;">
<div id="divJavaHelp">
                                    <noscript>
                                        <div style="color: red">
                                            Першочергово, Вам необхідно увімкнути JavaScript
                                            <a href="http://www.google.ru/support/bin/answer.py?answer=23852"
                                               target="_blank">(інструкції
                                            </a>
                                            для
                                            <a href="http://help.rambler.ru/common/1201/" target="_blank">Internet
                                                Explorer</a>,
                                            <a href="http://help.rambler.ru/common/1202/" target="_blank">Mozilla
                                                Firefox</a>,
                                            <a href="http://help.rambler.ru/common/1203/" target="_blank">Opera</a>,
                                            <a href="http://help.rambler.ru/common/1204/" target="_blank">Safari</a>,
                                            <a href="http://help.rambler.ru/common/1205/" target="_blank">Google
                                                Chrome</a>)
                                            та перезавантажити сторінку.
                                            <br></br>
                                        </div>
                                    </noscript>
	<div id="divJavaHelp2" hidden="hidden" style="width:80%; margin-left: 200px;">
                                <p align="justify">Шановні відвідувачі, для успішного подання документів в електронній формі, на Вашому комп’ютері повинен бути встановлений пакет (плагін) Java.
                                </p>
<input type="button" id="btnTestJavaNow" onclick="TestJavaNow()" value="Перевірити Java зараз" /><br><br>
<?php echo CHtml::image(Yii::app()->request->baseUrl.'/images/JavaRun.png', 'Вікно запуску Java-аплету', array("width"=>"32%", "title"=>"Натисніть кнопку Run")); ?>
 <?php echo CHtml::image(Yii::app()->request->baseUrl.'/images/JavaAllow.png', 'Вікно дозволів Java-аплету', array("width"=>"31%", "title"=>"Натисніть кнопку Allow")); ?>
<br>
                                <h3>Примітки:</h3>
                                <ol>
                                    <li>Детальні інструкції з встановлення та перевірки Java знаходяться
                                        на сайті <a target="_blank" href="http://java.com/ru/download/installed.jsp">
                                            http://java.com/ru/download/installed.jsp</a>.</li>
									<li>Безпосередньо Java для Windows можна завантажити з <a target="_blank" href="http://www.java.com/ru/download/windows_xpi.jsp"> http://www.java.com/ru/download/windows_xpi.jsp</a>.</li>		
                                    <li>У випадку використання браузеру GoogleChrome для появи спливаючого вікна необхідно
                                        натиснути «Запустить один раз».</li>
                                </ol>
								<p>
									Також необхідно дозволити завантаження та запуск Java-модулю.
								</p>
</div></div><br>
	                                <ul class="person-types unstyled" style="float:left; list-style: none; margin-top: 27px;">
                                        <li style="margin-bottom: 20px;"><a href="#" class="person-type fiz-person active" style="padding-top: 10px; padding-bottom: 10px;">
                                            <img src="/images/fizik.png" />
                                            <p>Я - фіз. особа</p>
                                            </a>
                                        </li>
                                        <li><a href="#" class="person-type ur-person" style="padding-top: 10px; padding-bottom: 10px;">
                                            <img src="/images/urik.png" />
                                            <p>Я - юр. особа</p>
                                            </a>
                                        </li>
                                    </ul>
<input type="hidden" id="type_of_user" name="type_of_user" value="0"></input>									
<div class="container" style="margin-left:170px;">
<div style="float:left;">
<?php //$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Login', 'model'=>$model));
	$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden', 'model'=>$model));
	?>

<div id="divMainRegForm" ><table><tr><td style="width:50%;"><span align=left style="width:30%;">
	
<div class="form">
<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'reg-form',
	'action' => '#',//Yii::app()->createUrl('sign/register'),
	'enableClientValidation'=>true,
	'enableAjaxValidation'=>false,
	'clientOptions'=>array(
		'validateOnSubmit'=>true,
		'validateOnChange'=>true,
//		'afterValidate' => 'js:afterValidate',
	),
)); ?>
  <div style="float:left; width:50%;">
	<div class="row">
		<?php echo $form->hiddenfield($model,'Signature'); ?>
		<?php echo $form->error($model,'Signature',array('hideErrorMessage'=>'true')); ?>
	</div>
	
	<div class="row eusign">
		<?php echo $form->labelEx($model,'Email'); ?>
		<?php echo $form->emailField($model, 'Email',array('placeholder'=>'Електронна пошта', 'class'=>'edit eusign')); ?>
		<?php echo $form->error($model,'Email'); ?>
	</div>	

	<div class="row usign">
		<?php echo $form->labelEx($model,'Email2'); ?>
		<?php echo $form->emailField($model, 'Email2',array('placeholder'=>'Підтвердження електронної пошти', 'class'=>'edit eusign')); ?>
		<?php echo $form->error($model,'Email2'); ?>
	</div>

	<div class="row eusign">
		<?php echo $form->labelEx($model,'Phone'); ?>
		<?php echo $form->telField($model, 'Phone',array('placeholder' => 'Ваш номер телефону', 'class'=>'edit eusign')); ?>
		<?php echo $form->error($model,'Phone'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton('Реєстрація',array('onclick'=>'return signd(); return false;', 'class'=>'eusign')); ?>
	</div>
  </div>
  <div style="float:right; width:50%;">
	<div class="eusign" style="text-align:justify; position:relative; top:5px;">
		<?php echo $form->labelEx($model, 'Acceptance'); ?>
		<?php echo $form->checkBox($model, 'Acceptance', array('uncheckValue')); ?>
		<?php echo $form->error($model, 'Acceptance'); ?>
	</div>
  </div>

<?php $this->endWidget(); ?>
</div><!-- form -->	
	</span></td>

	</tr>
	<tr><td><span align=left style="width:30%;">
		<input type="button" class="eusign" value="Налаштування" onclick='$("#proxy_div").show(); $("#proxy_window").dialog("open");' />
	<?php
		$countFreeIntUsers = CabUser::model()->count(new CDbCriteria(array
		(
			'condition' => 'user_roles_id < 4 and cab_state = "не активований"' //Пошук неактивованих внутрішніх користувачів
//			'params' => array(':people_id'=>$people->id)
		)));
		if ($countFreeIntUsers > 0) {	// Є необхідність подавати запити на реєстрацію з кодом активації
			echo '<input type="button" class="eusign" value="Спеціальний запит" onclick=\'window.location="'.Yii::app()->createAbsoluteUrl('sign/register2').'";\' style="float: right;" />';
		}
	?>
	</span></td>
	</tr>
	
	</table></div></a>


</div>  

</div>

</td><td style="vertical-align: top; ">
<div id="servmenu" class="container">



</div></td></tr></table>




<script type="text/javascript">
    $( window ).load(function() {
		var euSign = document.getElementById("euSign");
		try {
			euSign.SetCharset("UTF-16LE");
			euSign.SetUIMode(false);
			euSign.Initialize();
			euSign.width = "1px";
			euSign.SetUIMode(false);
			authForm_GetProxy();
			euSign.Finalize();
			document.getElementById("divMainRegForm").hidden = "";
			document.getElementById("divJavaHelp").hidden = "hidden";
		} catch(e) { 
			document.getElementById("divJavaHelp").hidden = "";
			document.getElementById("divJavaHelp2").hidden = "";
			document.getElementById("divMainRegForm").hidden = "hidden";
			alert("Помилка ініціалізації Java-аплету:"+euSign.GetLastErrorCode()); 
		}
		
    });
	
    function proxy_window_SetProxy() {
        var euSign = document.getElementById("euSign");
        try {
            euSign.SetCharset("UTF-16LE");
            euSign.SetUIMode(false);
            euSign.Initialize();
            euSign.width = "1px";
            euSign.SetUIMode(false);
            authForm_SetProxy();
            euSign.Finalize();
        } catch (e) {
            try {
                euSign.Finalize();
            } catch (e) {
            }
        }
    }

    function proxy_window_GetProxy() {
        var euSign = document.getElementById("euSign");
        try {
            euSign.SetCharset("UTF-16LE");
            euSign.SetUIMode(false);
            euSign.Initialize();
            euSign.width = "1px";
            euSign.SetUIMode(false);
            authForm_GetProxy();
            euSign.Finalize();
        } catch (e) {
            try {
                euSign.Finalize();
            } catch (e) {
            }
        }
    }	
function personTypesSwitcher() {
    var personTypes = $('.person-types .person-type');
    var fizPerson   = $('.person-types .fiz-person');
    var urPerson    = $('.person-types .ur-person');
//    var legalInput  = $('.legal-input');
	var typeOfUser     = $('#type_of_user');

    fizPerson.on('click', function(e){
        e.preventDefault();
        personTypes.removeClass('active');
        $(this).addClass('active');
//        legalInput.hide().find('#legal_person').removeClass('validate[required]');
        typeOfUser.val(0);

//        $('.formError').remove();
    });
    urPerson.on('click', function(e){
        e.preventDefault();
        personTypes.removeClass('active');
        $(this).addClass('active');
//        legalInput.show().find('#legal_person').addClass('validate[required]');
        typeOfUser.val(1);

//        $('.formError').remove();
    });
} 
personTypesSwitcher();
</script>

<script language="javascript" type="text/javascript">
    function TestJavaNow() {
	var euSign = document.getElementById("euSign");
	try {
	    euSign.SetCharset("UTF-16LE");
	    euSign.SetUIMode(false);
	    euSign.Initialize();
	    euSign.width = "1px";
	    euSign.SetUIMode(false);
	    if (euSign.IsInitialized()) {
		euSign.Finalize();
		document.getElementById("btnTestJavaNow").style.backgroundColor = "green";
		document.getElementById("btnTestJavaNow").value = "Java-аплет перевірено";
		$('#divJavaHelp').slideUp();
	    }
	} catch (e) {
		try {
			alert("Виникла помилка при перевірці Java-аплету. Код помилки: "+euSign.GetLastErrorCode());
			euSign.Finalize();
		} catch (e) {
			alert("Необхідний Java-модуль не завантажений. Здійсніть оновлення сторінки. Якщо помилка залишається - виконайте інструкції, наведені у примітках.");
		}
	}
    }
</script>

<script>
	function signd() {
// simple validation
		if (document.getElementById("RegForm_Acceptance").checked == "") {
			alert("Для продовження реєстрації Ви повинні надати згоду на обробку персональних даних");
			return false;
		}
		if ((document.getElementById("RegForm_Email").value == "") || (document.getElementById("RegForm_Email2").value == "")) {
			alert("Поле для поштової адреси не може бути порожнім");
			return false;
		}
		if (document.getElementById("RegForm_Email").value != document.getElementById("RegForm_Email2").value) {
			alert("Введені адреси електронної пошти повинні співпадати");
			return false;
		}
		if (document.getElementById("RegForm_Phone").value == "") {
			alert("Поле для номера телефону не може бути порожнім");
			return false;
		} else if ($.isNumeric(document.getElementById("RegForm_Phone").value) == false) {
			alert("Поле для номера телефону повинно містити тільки цифри");
			return false;
		}
		
		var $form = $('#reg-form'), settings = $form.data('settings');
		settings.submitting = true;
		var errorsExist = false;
		$.fn.yiiactiveform.validate($form, function(mes) {
			delete mes.RegForm_Signature;
			hasError = false;
			$.each($('#reg-form').data('settings').attributes, function () {
				if(this.id != 'RegForm_Signature') {	// this = attribute of form. Signature is hidden, so no need to show error, because it was not created yet
					hasError = $.fn.yiiactiveform.updateInput(this, mes, $('#reg-form')) || hasError;
				}
            });
//			alert(hasError);
//            $.fn.yiiactiveform.updateSummary($('#reg-form'), mes);
			if($.isEmptyObject(mes)) { // valid
//  Variable sign scenario, depending on type of user	
				var typeOfUser = document.getElementById("type_of_user");
				if (typeOfUser.value == 1) {	// 0-Fiz osoba; 1-Ur osoba
					alert("Підключіть носій з ключом ЕЦП керівника установи");
				}
				
				var euSign = document.getElementById("euSign");
//		euSign.SetCharset("UTF-16LE");
//		euSign.SetUIMode(false);
//		euSign.Initialize();
//		euSign.width = "1px";
//		euSign.SetUIMode(false);
// Agreement text
				text1=$("[for=RegForm_Acceptance]").text();
				text1 = text1.substring(0, text1.length - 2);
				var tosign = document.getElementById("RegForm_Email").value+";"+document.getElementById("RegForm_Email2").value+";"+document.getElementById("RegForm_Phone").value+";"+text1;
//		tosign="123321"+"";
				var DataToSign = tosign;
				EUWidgetSign(DataToSign, false, ";", false, aftersign, ";", "", aftersign_waitfunction);
				return false;
			} else {  // invalid        
//        alert('invalid data');
				errorsExist = true;
				return false;
			}
		});
	}
	
	function aftersign($signed_data, $original_data64) {
		try {
			var typeOfUser = document.getElementById("type_of_user");
			if(typeOfUser.value == 1) {
//				document.getElementById("first_sign").value = signed_data;
				alert("Тепер необхідно підключити носій з ключом електронної печатки та підписати заявку з використанням цього ключа. Після підключення носія натисніть кнопку ОК");
				EUWidgetSign($signed_data, false, ";", false, aftersign2, ";", "", aftersign_waitfunction);
			} else {
				euSign.SetCharset("UTF-16LE");
				euSign.SetUIMode(false);
				euSign.Initialize();
				euSign.width = "1px";
				euSign.SetUIMode(false);
//				var pd = euSign.BASE64Decode($original_data64);
				var truevalid=$signed_data;
//				euSign.WriteFile("C:\\Users\\Dencom\\0002.p7s", euSign.BASE64Decode(truevalid));
//				var SignInfo = euSign.VerifyInternal($signed_data);
				var SignInfo = euSign.VerifyInternal(truevalid);
//				alert(euSign.BytesToString(SignInfo.GetData()));
				euSign.Finalize();
				$(".hidescreen,.load_page").fadeOut(600);
				document.getElementById("RegForm_Signature").value = $signed_data;
				var em = document.getElementById("RegForm_Email").value;
				var params = new Array(); params["Signature"] = $signed_data; params["Email"] = em;
				params["Email2"] = document.getElementById("RegForm_Email2").value;
				params["Phone"] = document.getElementById("RegForm_Phone").value;
				params["Acceptance"] = document.getElementById("RegForm_Acceptance").value;
				params["TypeOfUser"] = document.getElementById("type_of_user").value;
				post('register', params);
			}
		} catch(e) { alert("Помилка підпису. Код:"+euSign.GetLastErrorCode()); euSign.Finalize();}
	}

	function aftersign2($signed_data, $original_data64) {
		try {
			euSign.SetCharset("UTF-16LE");
			euSign.SetUIMode(false);
			euSign.Initialize();
			euSign.width = "1px";
			euSign.SetUIMode(false);
//				var pd = euSign.BASE64Decode($original_data64);
			var truevalid=$signed_data;
//			var Cert2ExpireBeginTime = "";
//			var Cert2ExpireEndTime = "";
//console.log("signed_data:"+truevalid);
//			if(truevalid.indexOf(';') > 0) {
//				Cert2ExpireBeginTime = truevalid.substr(truevalid.indexOf(';')+1);
//				Cert2ExpireEndTime = Cert2ExpireBeginTime.substr(Cert2ExpireBeginTime.indexOf(';')+1);
//				Cert2ExpireBeginTime = Cert2ExpireBeginTime.substr(0, Cert2ExpireBeginTime.indexOf(';'));
//				truevalid = truevalid.substr(0, truevalid.indexOf(';'));
//			}
//console.log("signed_data_cutted:"+truevalid);
//				euSign.WriteFile("C:\\Users\\Dencom\\0002.p7s", euSign.BASE64Decode(truevalid));
//				var SignInfo = euSign.VerifyInternal($signed_data);
//			if (euSign.GetSignsCount(truevalid) == 2) {
//				alert(truevalid);
				var SignInfo1 = euSign.VerifyInternal(truevalid);
				var SignedData1 = SignInfo1.GetDataString("UTF-16LE");
				SignedData1 = SignedData1.substr(0, SignedData1.indexOf(';'));
				var SignInfo2 = euSign.VerifyInternal(SignedData1);
//				var SignedData2 = SignInfo2.GetDataString("UTF-16LE");
//				var OwnerInfo1 = SignInfo1.GetOwnerInfo();
//				var OwnerInfo2 = SignInfo2.GetOwnerInfo();
//				alert(OwnerInfo1.GetSubjCN());
//				alert(OwnerInfo2.GetSubjCN());

//			} else {alert("Виникла помилка при накладанні додаткових ЕЦП. Будь-ласка, виконайте процедуру з дотриманням інструкцій, що з'являються на екрані."); return false;}
//				alert(euSign.BytesToString(SignInfo.GetData()));
			euSign.Finalize();
			$(".hidescreen,.load_page").fadeOut(600);
			document.getElementById("RegForm_Signature").value = $signed_data;
			var em = document.getElementById("RegForm_Email").value;
			var params = new Array(); params["Signature"] = truevalid; params["Email"] = em;
			params["Email2"] = document.getElementById("RegForm_Email2").value;
			params["Phone"] = document.getElementById("RegForm_Phone").value;
			params["Acceptance"] = document.getElementById("RegForm_Acceptance").value;
			params["TypeOfUser"] = document.getElementById("type_of_user").value;
//			params["Cert2ExpireBeginTime"] = Cert2ExpireBeginTime;
//			params["Cert2ExpireEndTime"] = Cert2ExpireEndTime;
			post('register', params);
		} catch(e) { alert("Помилка підпису. Код:"+euSign.GetLastErrorCode()); euSign.Finalize(); $(".hidescreen,.load_page").fadeOut(600);}
	}
	
	function aftersign_waitfunction(wait_state) {
		if (wait_state == "wait_on") {
	        $(".hidescreen,.load_page").fadeIn(10);
//			document.getElementById("div_loading").style.display="block";
//			document.getElementById("div_hidescreen").style.display="block";
		}
		if (wait_state == "wait_off") {
	        $(".hidescreen,.load_page").fadeOut(600);
		}
	}

	function FillDataToSign(){
		document.getElementsByName("RegForm[Signature]")[0].value = document.getElementById("reg-form[Email]").value+";"+document.getElementById("reg-form[Email2]").value+";"+document.getElementById("reg-form[Phone]").value;
	}
</script>