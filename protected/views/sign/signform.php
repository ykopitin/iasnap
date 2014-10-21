<?php
/* @var $this AuthController */
/* @var $model RegForm */
/* @var $form CActiveForm  */

$this->breadcrumbs=array(
	'Auth',
);
?>
<h1>Введення даних</h1>
<script type="text/javascript">
    $( window ).load(function() {
		var euSign = document.getElementById("euSign");
		try {
			euSign.SetCharset("UTF-16LE");
			euSign.SetUIMode(false);
			euSign.Initialize();
			euSign.width = "1px";
			euSign.SetUIMode(false);
//			authForm_GetProxy();
			euSign.Finalize();
			document.getElementById("divJavaHelp").hidden = "hidden";
		} catch(e) { 
			document.getElementById("divJavaHelp").hidden = "";
			document.getElementById("divJavaHelp2").hidden = "";
			alert("Помилка ініціалізації Java-аплету:"+euSign.GetLastErrorCode()); 
		}
		
    });
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
	<div id="divJavaHelp2" hidden="hidden">
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

<form action="signform" id="Signform">
	<fieldset>
		<label for="signform_tema">Тема заяви:</label>
		<input type="text" id="signform_tema" /><br>
		<label for="signform_data">Текст заяви:</label>
		<input type="text" id="signform_data" /><br>
	</fieldset>
	<input type="submit" onclick="signd(); return false;" value="Відправити" />
</form>
<!-- form -->
<label><input id="ProxyUse" type="checkbox" onclick="Use_Proxy_Check()"/>Проксі-сервер</label>
<?php
    $this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden', 'model'=>$model));
?>
<script>
	function signd() {
		var euSign = document.getElementById("euSign");
		euSign.SetCharset("UTF-16LE");
		euSign.SetUIMode(false);
		euSign.Initialize();
		euSign.width = "1px";
		euSign.SetUIMode(false);
		var tosign = document.getElementById("signform_tema").value+";"+document.getElementById("signform_data").value;
		var DataToSign = tosign;
		EUWidgetSign(DataToSign, false, "", false, aftersign, ";");
		return false;
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
			euSign.Finalize();
//			document.getElementById("RegForm_Signature").value = $signed_data;
			post('signform', {Signform: $signed_data});
		} catch(e) { alert("Помилка підпису. Код:"+euSign.GetLastErrorCode()); euSign.Finalize();}
}

	function FillDataToSign(){
		document.getElementsByName("RegForm[Signature]")[0].value = document.getElementById("reg-form[Email]").value+";"+document.getElementById("reg-form[Email2]").value+";"+document.getElementById("reg-form[Phone]").value;
	}
</script>