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
</div></div><br>
<div class="container" style="margin-left:312px;">
<div style="float:left;">
<div id="divMainRegForm"><table><tr><td style="width:50%;"><span align=left style="width:30%;">
<div class="form">
<?php $form=$this->beginWidget('CActiveForm', array(
//	'id'=>'regrequest-form',
//	'action' => Yii::app()->createUrl('sign/regrequest'),
//	'enableClientValidation'=>false,
//	'clientOptions'=>array(
//		'validateOnSubmit'=>false,
//	),

	'id'=>'regrequest-form',
	'action' => '#',//Yii::app()->createUrl('sign/register'),
	'enableClientValidation'=>true,
	'enableAjaxValidation'=>false,
	'clientOptions'=>array(
		'validateOnSubmit'=>true,
		'validateOnChange'=>true,
	),
)); ?>

	<div class="row">
		<?php echo $form->hiddenfield($model,'Signature'); ?>
		<?php echo $form->error($model,'Signature'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model, 'activ_code'); ?>
		<?php echo $form->textField($model, 'activ_code',array('placeholder'=>'Спеціальний код', 'class'=>'edit eusign')); ?>
		<?php echo $form->error($model,'activ_code'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton('Продовжити',array('onclick'=>'return signd(); return false;', 'class'=>'eusign')); ?>
	</div>

<?php $this->endWidget(); ?>
</div><!-- form -->	

	</span></td>

	</tr>
	<tr><td><span align=left style="width:30%;">
		<input type="button" class="eusign" value="Налаштування" onclick='$("#proxy_div").show(); $("#proxy_window").dialog("open");' />
	</span></td>
	</tr>
	
	</table></div>


</div>  
<?php //$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Login', 'model'=>$model));
	$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden', 'model'=>$model));
	?>
</div>

</td><td style="vertical-align: top; ">
<div id="servmenu" class="container">



</div></td></tr></table>




<script type="text/javascript">
    $( window ).load(function() {
		var euSign = document.getElementById("euSign");
		try {
			document.getElementById("divJavaHelp").hidden = "";
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
	    alert("Виникла помилка при перевірці Java-аплету. Код помилки: "+euSign.GetLastErrorCode());
	    euSign.Finalize();
	}
    }
</script>

<script>
	function signd() {
// simple validation
		if (document.getElementById("RegrequestForm_activ_code").value == "") {
			alert("Для продовження Ви повинні ввести спеціальний код");
			return false;
		}
//		var $form = $('#reg-form'), settings = $form.data('settings');
//		settings.submitting = true;
//		var errorsExist = false;
//		$.fn.yiiactiveform.validate($form, function(mes) {
//			delete mes.RegrequestForm_Signature;
//			hasError = false;
//			$.each($('#regrequest-form').data('settings').attributes, function () {
//				if(this.id != 'RegrequestForm_Signature') {	// this = attribute of form. Signature is hidden, so no need to show error, because it was not created yet
//					hasError = $.fn.yiiactiveform.updateInput(this, mes, $('#regrequest-form')) || hasError;
//				}
 //           });
//			if($.isEmptyObject(mes)) { // valid
				var euSign = document.getElementById("euSign");
				var tosign = document.getElementById("RegrequestForm_activ_code").value;
				var DataToSign = tosign;
				EUWidgetSign(DataToSign, false, "", false, aftersign, ";", "", aftersign_waitfunction);
				return false;
//			} else {  // invalid        
//			errorsExist = true;
//			return false;
//			}
//		});
	}
	
	function aftersign($signed_data, $original_data64) {
		try {
			euSign.SetCharset("UTF-16LE");
			euSign.SetUIMode(false);
			euSign.Initialize();
			euSign.width = "1px";
			euSign.SetUIMode(false);
			var truevalid=$signed_data;
			var SignInfo = euSign.VerifyInternal(truevalid);
//			alert(euSign.BytesToString(SignInfo.GetData()));
			euSign.Finalize();
			$(".hidescreen,.load_page").fadeOut(600);
			document.getElementById("RegrequestForm_Signature").value = $signed_data;
			var params = new Array();
			params["Signature"] = $signed_data;
			post('register2', params);
		} catch(e) { alert("Помилка підпису. Код:"+euSign.GetLastErrorCode()); euSign.Finalize();}
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

