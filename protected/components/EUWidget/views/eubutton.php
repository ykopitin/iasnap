<?php
/* @var $model AuthForm */
?>

<style type="text/css">
label .eusign{
    display: block;
    padding-left: 15px;
    text-indent: -15px;
}
checkbox .eusign{
    width: 13px;
    height: 13px;
    padding: 0;
    margin:0;
    vertical-align: bottom;
    position: relative;
    top: -1px;
    *overflow: hidden;
}
</style>

<applet codebase="http://sign.eu.iit.com.ua"
	code="com.iit.certificateAuthority.endUser.libraries.signJava.EndUser.class"
	cache_archive="Java.jar"
	cache_version="1.3.51"
	archive="EUSignJava.jar"
	id="euSign"
	width="100%"
	height="16">
</applet>
<script type="text/javascript">
<?php echo "function YiiBaseUrl() { return ".'"'.Yii::app()->baseUrl.'";'." };\n"; ?>
<?php
	echo "function YiiUrl(Where) { if (Where=='base') {return ".'"'.Yii::app()->baseUrl.'";'."};
		if (Where=='getcertificates'){return ".'"'.Yii::app()->createUrl("sign/getcertificates").'";'."};
		if (Where=='getstring'){return ".'"'.Yii::app()->createUrl("sign/getstring").'";'."};

}";

?>
</script>

                <!--	Елементи opaco та popup необхідні для коректного відображення форми вибору носія закритого ключа та форми параметрів	-->
                <div id="opaco" class="hidden"></div>
                <div id="popup" class="hidden"></div>
<div>
<?php //if ($this->WidgetType == 'Login') $act = 'sign/login'; else if ($this->WidgetType == 'Sign') $act = 'auth/regconfirm';
    if ($this->WidgetType != 'Hidden') {
	$form=$this->beginWidget('CActiveForm', array(
	'id'=>'AuthForm',
	'action' => Yii::app()->createUrl($this->WidgetAction),
	'enableClientValidation'=>false,
	'clientOptions'=>array(
		'validateOnSubmit'=>false,
		),
	));
	echo '<div class="row">';
		echo $form->hiddenfield($this->model,'Signature');
	echo '</div>';

	echo '<div class="row buttons">';
		$url= "'".Yii::app()->baseUrl."'";
		if ($this->WidgetType == 'Login')
			echo CHtml::submitButton('Вхід за ЕЦП', array('onclick'=>'authForm_SetProxyAndSignIn(); return false;'));
		else 
			echo CHtml::submitButton('Підписати', array('onclick'=>'return authForm_SignIn();'));
error_log("WidgetType:".$this->WidgetType);	
	echo '</div>';

$this->endWidget();
echo '</div><!-- form -->';
}
?>

<input id="OwnCertPath" type="hidden" value="" />


<input id="SignRandstr" type="hidden" value="" />

<?php if ($this->WidgetType!="Hidden")
echo '<label><input id="ProxyUse" type="checkbox" onclick="Use_Proxy_Check()"/>Проксі-сервер</label><br>';
?>

<div class="eusign" id="proxy-settings" style="display: none;" >
<input id="ProxyName" type="text" value="" placeholder="Адреса проксі-сервера" /><br>
<input id="ProxyPort" type="text" value="" placeholder="Порт проксі-сервера" /><br>

<div>
<label><input id="ProxyAnonymous" type="checkbox" onclick="Use_Proxypas_Check()" />Авторизація на проксі-сервері</label><br>
</div>
<div id="proxy-auth" style="display: none;" >
<input id="ProxyUser" type="text" value="" placeholder="Ім'я користувача" /><br>
<input id="ProxyPass" type="password" value="" placeholder="Пароль" /><br>
<input id="OwnCertPath" type="hidden" value="" /><br>
</div>
</div>
</div>

