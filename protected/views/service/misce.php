<?


echo '<p><b><font size=4> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->name.'</font></b></p>';

echo '<b>Адреса:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->street.', '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->building.'<br>';

echo '<b>Режим роботи:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->working_time.'<br>';

echo '<b>E-mail:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->email.'<br>';

echo '<b>Веб-сайт:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->web.'<br>';

echo '<b>Телефон:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->phone.'<br>';

echo '<b>Факс:</b> '.GenAuthorities::model()->findByPk(GenServices::model()->findByPk($_GET['param'])->subjnap_id)->fax.'<br>';

?>