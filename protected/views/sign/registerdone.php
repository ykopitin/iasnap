<?php
/* @var $this AuthController */
/* @var $model AuthForm */

$this->breadcrumbs=array(
	'Auth',
);
?>
<h1><?php echo $this->id . '/' . $this->action->id; ?></h1>

<p>
	Вітаємо! Відтепер ви зареєстрований користувач
</p>
<p>
	<a href="<?php echo Yii::app()->CreateURL('sign/login'); ?>">Увійти</a>
</p>