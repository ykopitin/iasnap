<?php
/* @var $this DefaultController */

$this->breadcrumbs=array(
	$this->module->name,
);
$root_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data.png","Корень",array("width"=>24,"height"=>24));
$parent_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_up.png","Родители",array("width"=>24,"height"=>24));
$add_img = CHtml::image(Yii::app()->request->baseUrl."/protected/modules/mff/img/data_add.png","Добавить",array("width"=>24,"height"=>24));
$topparentid = (isset($parentid) && $parentid!=NULL)?FormRegistry::model()->findByPk($parentid)->parent:NULL;
$this->menu = array(
        array("label"=>$root_img."Корень","url"=>array("default/index","parentid"=>"")),
        array("label"=>$parent_img."Родители","url"=>array("default/index","parentid"=>$topparentid)),
        array("label"=>" ", "itemOptions"=>array("style"=>"border-top: double #55b")),
        array("label"=>$add_img."Добавить","url"=>array("default/index")),
);
$criteria=new CDbCriteria();
$criteria->compare("parent", isset($parentid)?$parentid:null);
$dataProvider=new CActiveDataProvider("FormRegistry", array(
        'criteria' => $criteria,
        'pagination' => array(
            'pageSize' => 30,
        )
    )
);
$this->widget("zii.widgets.ClistView", array(
    'dataProvider'=>$dataProvider,
    'itemView'=>'_view',
    'tagName'=>'table',
    'template'=>'<caption>{summary}</caption><thead><th>ID</th><th>PID</th><th>TABLE</th><th>Описание</th><th>Защищеный</th><th>Действия</th></thead><tbody>{items}</tbody>',
    
    )
);

if ($this->action->id=="edit") {
    $this->renderPartial("_edit",array("id"=>$id));
}
?>
<h1><?php echo $this->uniqueId . '/' . $this->action->id; ?></h1>

<p style="border-top: #000 solid thin">
This is the view content for action "<?php echo $this->action->id; ?>".
The action belongs to the controller "<?php echo get_class($this); ?>"
in the "<?php echo $this->module->id; ?>" module.
</p>
<p>
You may customize this page by editing <tt><?php echo __FILE__; ?></tt>
</p>
<?php echo $this->getModule()->getBasePath()."<br />";
      echo Yii::app()->request->baseUrl."<br />"; 
      
      ?>