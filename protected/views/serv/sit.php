<?php
$this->widget('zii.widgets.CMenu', array('encodeLabel'=>false, 'items' => GenLifeSituation::model()->getLifeMenu()));
?>
