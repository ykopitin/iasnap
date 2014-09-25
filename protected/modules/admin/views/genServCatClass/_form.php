<?php
/* @var $this GenServCatClassController */
/* @var $model GenServCatClass */
/* @var $form CActiveForm */
?>
<?php
$baseUrl = Yii::app()->baseUrl;
$cs = Yii::app()->getClientScript();
$cs->registerScriptFile($baseUrl.'/js/jquery.js');
?>
<script>


$( document ).ready(function() {
initialize();
});
function initialize(){

$i=document.getElementById("GenServCatClass_cat_class_id").value;
if($i!=""){//alert(document.getElementById("GenServCatClass_cat_class_id").value);
$.ajax({
   type: "POST",
   url: "http://allium2.soborka.net/iasnap/index.php/ajax/index",
////	'data' => 'js:{"input":"1"}',
    cache: false,
    data: "input="+$i,
	dataType:"json",
	success:function(output){
 // alert(output[0]);
//  alert(output[1]);
  $("#class").val(output[0]);
  $("#categorie").val(output[1]);
  },
});
}
}
function newres(){
var e = "";
var strUser ="";
e = document.getElementById("class");
strUser = e.options[e.selectedIndex].text;
if(strUser!='(Оберіть клас)')return strUser;
}
function newres1(){
var e = "";
var strUser ="";
e = document.getElementById("categorie");
strUser = e.options[e.selectedIndex].text;
if(strUser!='(Оберіть категорію)')return strUser;
}
</script>
<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'gen-serv-cat-class-form',
	// Please note: When you enable ajax validation, make sure the corresponding
	// controller action is handling ajax validation correctly.
	// There is a call to performAjaxValidation() commented in generated controller code.
	// See class documentation of CActiveForm for details on this.
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Поля з символом "<span class="required">*</span>" є обов'язковими для заповнення.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'service_id'); ?>
		<?php //echo $form->textField($model,'service_id'); ?>
		<?php echo $form->dropDownList($model, 'service_id', CHtml::listData(GenServices::model()->findAll(), 'id', 'name'),array('empty' => '(Оберіть послугу)')); ?>
		<?php echo $form->error($model,'service_id'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'cat_class_id'); ?>
		<?php echo $form->textField($model,'cat_class_id'); ?>
		<?php echo $form->error($model,'cat_class_id'); ?>
	</div>

		<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Створити' : 'Зберегти'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->

<?php 
		//categories
		$ss=array();
		$res = GenCatClasses::model()->findAll();
		foreach($res as $var)
		{
		$var1=$var->id;
		$ss[]=GenServCategories::model()->findByPK(GenCatClasses::model()->findByPK($var1)->categorie_id);
		}
		//class
		$zz=array();
		$res = GenCatClasses::model()->findAll();
		foreach($res as $var)
		{
		$var1=$var->id;
		$zz[]=GenServClasses::model()->findByPK(GenCatClasses::model()->findByPK($var1)->class_id);
		}

echo '<BR />';
 $select='';

echo CHtml::dropDownList('class', $select, 
              CHtml::listData($zz, 'id', 'item_name'),
              array('empty' => '(Оберіть клас)'));
echo CHtml::dropDownList('categorie', $select, 
              CHtml::listData($ss, 'id', 'name'),
              array('empty' => '(Оберіть категорію)'));
echo '<BR />';

echo CHtml::form();
echo CHtml::ajaxSubmitButton('Натисніть для формування переліку доступних категорій', Yii::app()->createUrl('ajax/dynamiccities'), array(
'type'=>'POST', //request type
'data'=> 'js:{"input":newres()}',
'cache'=> 'false',
'update'=>'#categorie', //selector to update
),
array(
    'type' => 'submit'
));
echo CHtml::endForm();

////////////////////////////////////////////////////////////////////////////////////////

echo CHtml::form();
echo CHtml::ajaxSubmitButton('Натисність для заповнення поля CatClass', Yii::app()->createUrl('ajax/showclasses'), array(
'type'=>'POST', //request type
'data'=> 'js:{"input":newres(),"input1":newres1()}',
'cache'=> 'false',
'success'=>'js:function(data){document.getElementById("GenServCatClass_cat_class_id").value=data}',
),
array(
    'type' => 'submit'
));
echo CHtml::endForm();?>