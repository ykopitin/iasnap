<?php /* @var $this Controller */ ?>
<?php $this->beginContent('//layouts/main'); ?>
<div id="content">    
<div id="container">

<?php
//if (!isset($_GET['param'])&& !isset($_POST['searchstr'])&& !isset($_GET['servid']) && !isset($_GET['idn'])){ include 'mainmenu.php' ;}
if ($_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/' || $_SERVER['REQUEST_URI']==Yii::app()->baseUrl.'/index.php' || (isset($_GET['class']) && !isset($_GET['param']) && !isset($_GET['servid']))){ include 'mainmenu.php' ;}
if (isset($_GET['param']) && !isset($_POST['searchstr'])){ include 'short.php';}
if (isset($_GET['class']) && isset($_GET['servid']) && !isset($_POST['searchstr']) && !isset($_GET['param']) ){ include 'shortserv.php';}
?>



</div> 
	<?php echo $content; ?>
</div><!-- content -->
<?php $this->endContent(); ?>