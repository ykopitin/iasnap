<?php
/* @var $model AuthForm */
?>

<style type="text/css">
label {
    display: block;
    padding-left: 15px;
    text-indent: -15px;
}
checkbox {
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
function YiiBaseUrl() {
	return "'".Yii::app()->baseUrl."'";
}
</script>

                <!--	Елементи opaco та popup необхідні для коректного відображення форми вибору носія закритого ключа та форми параметрів	-->
                <div id="opaco" class="hidden"></div>
                <div id="popup" class="hidden"></div>
<?php if ($this->WidgetType == 'Login') $act = 'auth/login'; else if ($this->WidgetType == 'Sign') $act = 'auth/regconfirm';
	$form=$this->beginWidget('CActiveForm', array(
	'id'=>'AuthForm',
	'action' => Yii::app()->createUrl($act),
	'enableClientValidation'=>false,
	'clientOptions'=>array(
		'validateOnSubmit'=>false,
	),
)); ?>
	<div class="row">
		<?php echo $form->hiddenfield($this->model,'Signature'); ?>
	</div>

	<div class="row buttons">
		<?php $url= "'".Yii::app()->baseUrl."'";
//		echo CHtml::submitButton('Auth',array('onclick'=>'return authForm_SignIn('.$url.');'));
		if ($this->WidgetType == 'Login')
			echo CHtml::submitButton('Вхід за ЕЦП', array('onclick'=>'return authForm_SignIn('.$url.');'));
		else echo CHtml::submitButton('Підписати', array('onclick'=>'return authForm_SignIn('.$url.');')); ?>
	
	</div>

<?php $this->endWidget(); ?>
</div><!-- form -->


<input id="OwnCertPath" type="hidden" value="" />


<input id="SignRandstr" type="hidden" value="" />
<div>
<label><input id="ProxyUse" type="checkbox" onclick="Use_Proxy_Check()" />ProxyUse</label><br>
</div>
<div id="proxy-settings" style="display: none;" >
<input id="ProxyName" type="text" value="" /><br>
<input id="ProxyPort" type="text" value="" /><br>

<div>
<label><input id="ProxyAnonymous" type="checkbox" onclick="Use_Proxypas_Check()" />ProxyUsePassword</label><br>
</div>
<div id="proxy-auth" style="display: none;" >
<input id="ProxyUser" type="text" value="" /><br>
<input id="ProxyPassword" type="password" value="" /><br>
<input id="OwnCertPath" type="hidden" value="" /><br>
</div>
</div>

