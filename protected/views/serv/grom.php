<?php

$this->widget('zii.widgets.CMenu', array('encodeLabel'=>false,  'items' => GenServCategories::model()->getGromMenu()));

?>