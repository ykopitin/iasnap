<?php /* @var $this Controller */ ?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="language" content="en" />

	<!-- blueprint CSS framework -->
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/screen.css" media="screen, projection" />
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/print.css" media="print" />
	<!--[if lt IE 8]>
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/ie.css" media="screen, projection" />
	<![endif]-->

	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/main.css" />
    <link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/style.css" />
	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/form.css" />
    	<link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/leftacc.css" />
        <link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/acc.css" />
        <link rel="stylesheet" type="text/css" href="<?php echo Yii::app()->request->baseUrl; ?>/css/path.css" />
  

  
  
  
	<title><?php echo CHtml::encode($this->pageTitle); ?></title>



<script type="text/javascript" src="//yastatic.net/share/share.js"
charset="utf-8"></script>




    <script> 
function func(n) { 
    document.getElementById("m"+(n^1)).style.display = "none"; 
    document.getElementById("m"+n).style.display = "block"; 
    
    document.getElementById("n"+(n^1)).style.backgroundColor = "#ededed"; 
    document.getElementById("n"+n).style.backgroundColor = "#a2d507"; 
    
    document.getElementById("p"+(n^1)).style.background = "url('')"; 
    document.getElementById("p"+n).style.background = "url('<?php echo Yii::app()->baseUrl; ?>/images/strelka.png') no-repeat center top"; 
} 
</script>

<style>

</style>
</head>
<body>

<div id="allpage">



 
  <div id="cat"> 

  	<?php echo $content;?>
    </div>


</div>


   

</body>
</html>
