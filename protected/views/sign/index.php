<?php
/* @var $this AuthController */
/* @var $model AuthForm */
/* @var $form CActiveForm  */

$this->breadcrumbs=array(
	'Auth',
);
?>

<style>
input[type=submit].eusign {
	width: 283px;
	height: 44px;
	border-radius: 5px;
	background-color: #a2d507;
}
input[type=button].eusign {
	width: 283px;
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
		'position'=>array('my'=>'top','at'=>'top'),
    ),
));
?>

<div id="proxy_div" style="display: none;">
    <div>
        Якщо вихід до Інтернету здійснюється за допомогою проксі-сервера, необхідно вказати параметри підключення до
        нього
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


<div class="container">
<div>
<div id="divMainRegForm"><table><tr><td><span align=center style="width:30%;">
	
<div class="form" style="position: relative; width: 580px; margin: 0px auto;">
<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'auth-form',
	'action' => Yii::app()->createUrl('sign/login'),
	'enableClientValidation'=>false,
	'enableAjaxValidation'=>false,
	'clientOptions'=>array(
		'validateOnSubmit'=>false,
		'validateOnChange'=>false,
	),
)); ?>

	<div class="row">
		<?php echo $form->hiddenfield($model,'Signature'); ?>
		<?php echo $form->error($model,'Signature'); ?>
	</div>

	<div class="buttons">
		<?php echo CHtml::submitButton('Вхід за ЕЦП',array('onclick'=>'return signd(); return false;', 'class'=>'eusign')); ?>
		<input style="margin-left: 10px;" type="button" class="eusign" value="Налаштування" onclick='$("#proxy_div").show(); $("#proxy_window").dialog("open");' />
	</div>
	

<?php $this->endWidget(); ?>
	<p style="text-align: left; margin: 0px auto; width: 576px;">
		<a href="<?php echo Yii::app()->createAbsoluteUrl('sign/register'); ?>">Бажаєте зареєструватися?</a>
	</p><br>
	<h1>Повідомлення.</h1>
	<p style="text-align: justify;">
		На Порталі використовується система ідентифікації та автентифікації користувачів за електронним цифровим підписом (ЕЦП). Засоби накладання ЕЦП розміщені на Порталі, передаються відвідувачам за безпечним протоколом HTTPS та виконуються на комп'ютері користувача. Перед використанням засобів накладання ЕЦП, розміщених на Порталі, Ви маєте можливість перевірити справжність Порталу, виконав кроки, які наведені у Інструкції <a href="<?php echo Yii::app()->createAbsoluteUrl('instructions'); ?>" target="_blank">«Підтвердження достовірності порталу».</a>
	</p>
</div><!-- form -->	
	</span></td>
	</tr>
	
	</table>
<?php //$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Login', 'model'=>$model));
	$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden', 'model'=>$model));
	?>	
	</div>


</div>  

</div>



<script type="text/javascript">
    $( window ).load(function() {
		var euSign = document.getElementById("euSign");
		try {
			euSign.style.display="block";
			euSign.SetCharset("UTF-16LE");
			euSign.SetUIMode(false);
			euSign.Initialize();
			euSign.width = "1px";
			euSign.SetUIMode(false);
			authForm_GetProxy();
			euSign.Finalize();
			euSign.style.display="none";
			document.getElementById("divMainRegForm").style.display = "block";
			document.getElementById("divJavaHelp").style.display = "none";
		} catch(e) { 
			document.getElementById("divJavaHelp").style.display = "block";
			document.getElementById("divJavaHelp2").style.display = "block";
			document.getElementById("divMainRegForm").style.display = "none";
			alert("Помилка ініціалізації Java-аплету:"+euSign.GetLastErrorCode()); 
			euSign.style.display="none";
		}
		
    });
	
    function proxy_window_SetProxy() {
        var euSign = document.getElementById("euSign");
        try {
			euSign.style.display="block";
            euSign.SetCharset("UTF-16LE");
            euSign.SetUIMode(false);
            euSign.Initialize();
            euSign.width = "1px";
            euSign.SetUIMode(false);
            authForm_SetProxy();
            euSign.Finalize();
			euSign.style.display="none";
        } catch (e) {
            try {
                euSign.Finalize();
				euSign.style.display="none";
            } catch (e) {
            }
        }
    }

    function proxy_window_GetProxy() {
        var euSign = document.getElementById("euSign");
        try {
			euSign.style.display="block";
            euSign.SetCharset("UTF-16LE");
            euSign.SetUIMode(false);
            euSign.Initialize();
            euSign.width = "1px";
            euSign.SetUIMode(false);
            authForm_GetProxy();
            euSign.Finalize();
			euSign.style.display="none";
        } catch (e) {
            try {
                euSign.Finalize();
				euSign.style.display="none";
            } catch (e) {
            }
        }
    }
	
</script>
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
	<div id="divJavaHelp2" style="display: none">
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
<h3>Примітки:</h3>
<div id='accclassic'>
<?php							
$this->widget('zii.widgets.jui.CJuiAccordion',array(
    'panels'=>array(
		'Що робити, якщо з\'являється повідомлення про необхідність встановлення пакету Java?'=>'Таке повідомлення з\'являється, якщо браузер Користувача не може підтвердити наявність та працездатність зазначеного пакету Java. Цей пакет є необхідним компонентом системи Користувача, без якого Користувачу будуть доступні не всі функції Порталу, у тому числі реєстрація та вхід до власного кабінету. Інструкції з встановлення пакету Java наведені на <a href="https://www.java.com/ru/download/help/download_options.xml" target="_blank">довідковій сторінці про встановлення пакету Java</a>.',
		'Я встановив пакет Java, але все одно бачу повідомлення про необхідність встановлення пакету Java. Що робити?'=>'Якщо Користувач встановив пакет Java, але веб-сторінки повідомляють про його відсутність, можливо, необхідно активувати використання пакету. Перш за все, необхідно здійснити повний перезапуск веб-браузера (закрити всі вкладки та вікна, зачекати декілька секунд, знову відкрити веб-браузер). Більш детальні інструкції з вирішення цієї проблеми наведені на <a href="https://www.java.com/ru/download/help/troubleshoot_java.xml#running" target="_blank">довідковій сторінці про використання пакету Java</a>. Також, необхідно впевнитись, що веб-браузер не блокує функціонування Java. Як це зробити, наведено на <a href="https://www.java.com/ru/download/help/browser_activate_plugin.xml" target="_blank">довідковій сторінці про включення Java у веб-браузерах</a>.<br>',
		'Як виявити, що веб-браузер заблокував використання пакету Java?'=>'<div style="width: 46%; height: 100%; float: left;">
			<p style="text-align: justify;">
				<img src="'.Yii::app()->request->baseUrl.'/images/browser_icon/Google-Chrome-icon.png" align="left" style="margin-right: 10px" />
				Якщо браузер <b>Google Chrome</b> блокує виконання додаткових модулів, у тому числі Java, у верхньому правому куті з\'являється позначка про це - <img src="'.Yii::app()->request->baseUrl.'/images/browser_icon/Google-Chrome-instr01-blocked-icon.png" style="vertical-align: bottom" />. Необхідно клацнути по ній, та у меню обрати пункт "Разрешить плагины на сайте...".  Після цього перезавантажити сторінку.
				<div style="text-align: center">
					<img src="'.Yii::app()->baseUrl.'/images/browser_icon/Google-Chrome-instr02-allow-plugins.png" align="bottom" />
				</div>
			</p>
		</div>
		<div style="float: left; height: 100%; width: 46%;">
			<p style="text-align: justify;">
				<img src="'.Yii::app()->request->baseUrl.'/images/browser_icon/Firefox-icon.png" align="left" style="margin-right: 10px;" />
				Веб-браузер <b>Mozilla Firefox</b> повідомляє про заблоковані модулі у верхньому лівому куті за допомогою символу <img src="'.Yii::app()->request->baseUrl.'/images/browser_icon/Firefox-instr01-blocked-icon.png" style="vertical-align: bottom" />. Необхідно клацнути по цьому символу та натиснути кнопку "Разрешить и запомнить". Після цього оновити (перезавантажити) веб-сторінку.
				<div style="text-align: center">
					<img src="'.Yii::app()->request->baseUrl.'/images/browser_icon/Firefox-instr02-allow-plugins.png" align="bottom" />
				</div>
			</p>
		</div>',
    ),
	'options'=>array(
		'collapsible'=> true,
		'autoHeight'=>false,
		'active'=>false,
    ),
));	
?>					
</div>		
</div></div><br>
<script language="javascript" type="text/javascript">
    function TestJavaNow() {
	var euSign = document.getElementById("euSign");
	try {
		euSign.style.display="block";
	    euSign.SetCharset("UTF-16LE");
	    euSign.SetUIMode(false);
	    euSign.Initialize();
	    euSign.width = "1px";
	    euSign.SetUIMode(false);
	    if (euSign.IsInitialized()) {
		euSign.Finalize();
		euSign.style.display="none";
		document.getElementById("btnTestJavaNow").style.backgroundColor = "green";
		document.getElementById("btnTestJavaNow").value = "Java-аплет перевірено";
		$('#divJavaHelp').slideUp();
	    }
	} catch (e) {
		try {
			alert("Виникла помилка при перевірці Java-аплету. Код помилки: "+euSign.GetLastErrorCode());
			euSign.Finalize();
			euSign.style.display="none";
		} catch (e) {
			alert("Необхідний Java-модуль не завантажений. Здійсніть оновлення сторінки. Якщо помилка залишається - виконайте інструкції, наведені у примітках.");
			euSign.style.display="none";
		}
	}
    }
	
	
	
	function signd() {
		var euSign = document.getElementById("euSign");
		try {
			euSign.style.display="block";
			euSign.SetCharset("UTF-16LE");
			euSign.SetUIMode(false);
			euSign.Initialize();
			euSign.width = "1px";
			euSign.SetUIMode(false);
//		var tosign = document.getElementById("AuthForm_Signature").value;
//		tosign="123321"+"";
			var DataToSign = "";
			EUWidgetSign(DataToSign, false, ";", false, aftersign, "", aftersign_error, aftersign_waitfunction);
			return false;
		} catch (e) {
			alert("Виникла помилка при накладанні ЕЦП. Здійсніть оновлення сторінки або закрийте та відкрийте браузер та здійсніть спробу входу ще раз.");
			euSign.style.display="none";
		}
	}	
	
	function aftersign($signed_data, $original_data64) {
		try {
			euSign.style.display="block";
			euSign.SetCharset("UTF-16LE");
			euSign.SetUIMode(false);
			euSign.Initialize();
			euSign.width = "1px";
			euSign.SetUIMode(false);
//			var pd = euSign.BASE64Decode($original_data64);
			var truevalid=$signed_data;
			var SignInfo = euSign.VerifyInternal(truevalid);
			euSign.Finalize();
			euSign.style.display="none";
			$(".hidescreen,.load_page").fadeOut(600);
			document.getElementById("AuthForm_Signature").value = $signed_data;
			var params = new Array(); params["Signature"] = $signed_data;
			post('login', params);
			$(".hidescreen,.load_page").fadeIn(10);			
		} catch(e) { alert("Помилка підпису. Код:"+euSign.GetLastErrorCode()); euSign.Finalize();
			euSign.style.display="none";
		}
	}
	
    function aftersign_error(s_step, i_errorcode) {
    // EU_ERROR_TRANSMIT_REQUEST (5), EU_ERROR_PROXY_NOT_AUTHORIZED (8), EU_ERROR_DOWNLOAD_FILE (10),
    // EU_ERROR_GET_TIME_STAMP (65), EU_ERROR_GET_OCSP_STATUS (81), EU_ERROR_LDAP_ERROR (97)
        $(".hidescreen,.load_page").fadeOut(600);
		network_errors_array = [5, 8, 10, 65, 81, 97];
        if (($.inArray(i_errorcode, network_errors_array) > -1)) {
			$("#proxy_div").show();
            $("#proxy_window").dialog("open");
        }
//		console.log(s_step);
//		console.log(i_errorcode);
		
//		$("#btnSign").prop("disabled", false);
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
</script>


