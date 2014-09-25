<?php


class AjaxController extends CController {

function actionIndex(){
$input = Yii::app()->request->getPost('input');
//  $output = mb_strtoupper($input, 'utf-8');
//  echo CHtml::encode($output);
$zebra = array();
$zebra[] = GenCatClasses::model()->findByPk($input)->class_id;
$zebra[] = GenCatClasses::model()->findByPk($input)->categorie_id;
echo json_encode($zebra);	
Yii::app()->end();
}



function actionShowClasses(){
		
		$n1=Yii::app()->request->getPost('input1');
		$n2=Yii::app()->request->getPost('input');
		//echo GenServCategories::Model()->find('name=:name', array(':name'=>$n1))->id;
		$categorie=GenServCategories::Model()->find('name=:name', array(':name'=>$n1))->id;
		//echo '<BR />';
		//echo GenServClasses::Model()->find('item_name=:item_name', array(':item_name'=>$n2))->id;
		$service=GenServClasses::Model()->find('item_name=:item_name', array(':item_name'=>$n2))->id;
		//echo '<BR />';
		echo GenCatClasses::Model()->findBySql("SELECT * FROM gen_cat_classes WHERE categorie_id=$categorie AND class_id=$service")->id;
		////////////////////////////////////////////////////////////
		
Yii::app()->end();
}


public function actionDynamiccities()
{
        $input = Yii::app()->request->getPost('input');
	
		$prom1 = GenServClasses::model()->findBySQL("SELECT * FROM gen_serv_classes WHERE item_name=\"$input\"")->id;
		//echo $prom1;
		//echo '<BR />';
		$data=array();
		$res = GenCatClasses::model()->findAllBySQL("SELECT * FROM gen_cat_classes WHERE class_id=$prom1");
	////$res = GenCatClasses::model()->findAll();
		foreach($res as $var)
		{
		$var1=$var->id;
		//echo $var1;
	//	$data[]=GenServCategories::model()->findByPK(GenCatClasses::model()->findByPK($var1)->categorie_id);
        $prom = GenCatClasses::model()->findBySQL("SELECT * FROM gen_cat_classes WHERE id=$var1")->categorie_id;
       $data[] = GenServCategories::model()->findByPK($prom);
	   //echo $prom;
	  // echo '<BR />';
		}
	
	
	$data = CHtml::listData($data, 'id', 'name');
		
	foreach($data as $value=>$name)
    {
        echo CHtml::tag('option',
                   array('value'=>$value),CHtml::encode($name),true);
    }
}	

}
?>