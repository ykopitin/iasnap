<?php
/* @var $this AuthController */
/* @var $model AuthForm */

$this->breadcrumbs=array(
	'Auth',
);
?>
<h1><?php echo $this->id . '/' . $this->action->id; ?></h1>

<p>
	Signature test page
	the file <tt><?php echo __FILE__; ?></tt>.
</p>
<input id="SomeData" type="text" value="" placeholder="Дані для підпису" />
<input id="SomeButton" type="button" value="OK" onclick="var s=euSelectFile(); if(s){$('#SomeData').val(s)};" />
<?php
    $this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden', 'model'=>$model));
?>
<script>
// функція, яка записує всю строку для підпису в input text id =AuthForm[Signature],
// що створюється автоматично всередині віджету EUWidget
// При натисканні кнопки "Підписати" спочатку викликаєтся функція FillDataToSign, у якій
// необхідно вказати та обробити всі вхідні поля та записати до AuthForm[Signature],
// після чого викликається основний скрипт підпису та підписує це поле
	function FillDataToSign(){
		document.getElementsByName("AuthForm[Signature]")[0].value = document.getElementById("SomeData").value;
	}
</script>

