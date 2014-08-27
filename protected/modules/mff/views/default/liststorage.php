<?php
/* @var $this DefaultController */

$this->breadcrumbs=array(
	$this->module->name,
);
$this->menu = array(
        array("label"=>"Список форм","url"=>array("default/index")),
        array("label"=>"Список хранилищ","url"=>array("default/index")),
);
//$this->widget("zii.widgets.CMenu",array(
//    "items"=>array(
//        array("label"=>"Список форм","url"=>array("default/index")),
//        array("label"=>"Список хранилищ","url"=>array("default/index")),
//    )
//));
?>
<h1><?php echo $this->uniqueId . '/' . $this->action->id; ?></h1>

<p>
This is the view content for action "<?php echo $this->action->id; ?>".
The action belongs to the controller "<?php echo get_class($this); ?>"
in the "<?php echo $this->module->id; ?>" module.
</p>
<p>
You may customize this page by editing <tt><?php echo __FILE__; ?></tt>
</p>