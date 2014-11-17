<!--
<div id="wrapper">
	<div>
		<div class="sliderbutton"><img src="<?php echo Yii::app()->baseUrl; ?>/images/left.gif" width="32" height="38" alt="Previous" onclick="slideshow.move(-1)" /></div>
		<div id="slider">
			<ul>
				<li><img src="<?php echo Yii::app()->baseUrl; ?>/images/photos/000.jpg" width="600" height="300" alt="gggggggggg" /></li>
				<li><img src="<?php echo Yii::app()->baseUrl; ?>/images/photos/001.jpg" width="600" height="300" alt="yyyyyyyyyy" /></li>
				<li><img src="<?php echo Yii::app()->baseUrl; ?>/images/photos/002.jpg" width="600" height="300" alt="uuuuuuuuuu" /></li>
                	<li><img src="<?php echo Yii::app()->baseUrl; ?>/images/photos/003.jpg" width="600" height="300" alt="uuuuuuuuuu" /></li>
			</ul>
		</div>
		<div class="sliderbutton"><img src="<?php echo Yii::app()->baseUrl; ?>/images/right.gif" width="32" height="38" alt="Next" onclick="slideshow.move(1)" /></div>
	</div>
	<ul id="pagination" class="pagination">
		<li onclick="slideshow.pos(0)">1</li>
		<li onclick="slideshow.pos(1)">2</li>
		<li onclick="slideshow.pos(2)">3</li>
		<li onclick="slideshow.pos(3)">4</li>
	</ul>
</div>
<script type="text/javascript">
var slideshow=new TINY.slider.slide('slideshow',{
	id:'slider',
	auto:5,
	resume:true,
	vertical:false,
	navid:'pagination',
	activeclass:'current',
	position:0
});
</script>



<div id="maintext">
<h4>Дякуємо Вам за те, що обрали портал електронних послуг міста Одеси! </h4>
<p align='justify'>Тут Ви завжди зможете отримати інформацію про порядок та спосіб отримання адміністративних послуг, 
вивчити перелік необхідних документів або завантажити електронні форми заяв.</p>
<p align='justify'>Якщо ви маєте власний електронний цифровий підпис, Ви маєте можливість замовити деякі послуги в режимі on-line. 
Для замовлення on-line послуги, просимо Вас створити обліковий запис та перейти в необхідний розділ 
«<? echo CHtml::link(GenServClasses::model()->findByPk('2')->item_name, array('serv/?class=2'));?>» або 
«<? echo CHtml::link(GenServClasses::model()->findByPk('1')->item_name, array('serv/?class=1'));?>». 
Обліковий запис створюється на підставі реєстрації користувача на порталі електронних послуг за його персональною електронним 
цифровим підписом, що дозволить у подальшому отримувати інформацію про статус замовлення, візуалізувати історію попередніх замовлень, 
отримувати додаткову інформацію.</p>
</div>
-->