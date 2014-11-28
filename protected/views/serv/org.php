<?php
/* @var $this ServController */

$items=GenServCategories::model()->getOrgMenu();
var_dump($items);
//$this->widget('zii.widgets.CMenu', array('encodeLabel'=>false, 'items' => $items));

?>



