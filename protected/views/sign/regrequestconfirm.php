<?php
/* @var $this AuthController */
/* @var $model AuthForm */

?>
<h1><?php echo $this->id . '/' . $this->action->id; ?></h1>

<?php 
	if($model=="allow") echo "<p>Ваш запит направлений на розгляд адміністрацією порталу. Очікуйте подальших інструкцій.</p>"; else echo 'Системі не вдалося знайти запитувану дію "regrequest".';
?>
