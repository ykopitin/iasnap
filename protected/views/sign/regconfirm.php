<?php
/* @var $this AuthController */
/* @var $model AuthForm */

$this->breadcrumbs=array(
	'Auth',
);
?>

<p>
	<?php
        // add the script
        $cs = Yii::app()->getClientScript();
        $cs->registerCoreScript('jquery');	
		if (!isset($_GET['activationcode'])) {
			echo 'Ви майже завершили процес реєстрації. На поштову скриньку, вказану Вами при реєстрації, вислано листа з інструкцією з активації вашого облікового запису на Порталі.';
		} else {
			$AC = $_GET['activationcode'];
			if ((ctype_alnum($AC)==true)&&(strlen($AC) == 40)) { // a-zA-Z0-9 only
				$user = CabUser::model()->findByAttributes(array('str_activcode'=>$AC));
				if($user===null) {	// wrong activation code, or no users to activate
					echo '<p>Виникла помилка при активації Вашого облікового запису - код активації невірний. Це може бути спричинено наступним:</p>';
					echo '<ul><li>Ваш обліковий запис вже активований.</li>';
					echo '<li>Закінчився термін дії кода активації. Вам необхідно зареєструватися знову та підтвердити реєстрацію вчасно.</li>';
					echo '<li>Ви перейшли за некоректним посиланням. Для активації необхідно перейти за посиланням, яке надійшло Вам на вказану електронну поштову скриньку.</li></ul>';
				} else {
					if($user->time_activcode < time()) { // Time out for activation, user account must be deleted
						$user->delete();
						echo '<p>Виникла помилка при активації Вашого облікового запису - код активації невірний. Це може бути спричинено наступним:</p>';
						echo '<ul><li>Закінчився термін дії кода активації. Вам необхідно зареєструватися знову та підтвердити реєстрацію вчасно.</li>';
						echo '</ul><p>Будь-ласка, спробуйте здійснити реєстрацію повторно. Якщо помилка повториться, то зверніться за допомогою до онлайн-консультанта або за гарячою лінією (048) 705-45-74</p>';
						Yii::app()->end();
					}
//	Activating user
					$user->cab_state = "активований";
					$user->str_activcode = "";
					$user->time_activcode = 0;
					if($user->save()){
						echo '<p>Ви успішно активували обліковий запис. Тепер Ваш браузер виконає перехід до сторінки авторизації.</p>';
						echo '<p>Якщо протягом 10 секунд цього не сталося, натисніть на посилання <a href="'.Yii::app()->createAbsoluteUrl('sign/login').'">'.Yii::app()->createAbsoluteUrl('sign/login').'</a></p>';
						echo '<script type="text/javascript">';
						echo '$( window ).load(function() {';
						echo 'setTimeout(function () {';
						echo '	window.location = "'.Yii::app()->createAbsoluteUrl('sign/login').'";';
						echo '	}, 8000);';
						echo '});';
						echo '</script>';
					} else {
//	Some error in activating user. The best solution is to delete user with his certificate and try to reregister
error_log("regconfirm,found activcode,cannot save activated account,deleting user id:".$user->id);
						$user->delete();
						echo '<p>Виникла невідома помилка при активації Вашого облікового запису. Будь-ласка, спробуйте здійснити реєстрацію повторно. Якщо помилка повториться, то зверніться за допомогою до онлайн-консультанта або за гарячою лінією (048) 705-45-74</p>';
						echo '<p>'.Yii::app()->createAbsoluteUrl('sign/register').'</p>';
					}
				}
			}
			
		}
	?>
</p>
