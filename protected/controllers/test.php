<?php
function actionGetCertificates()
{
//	$certdir = $_SERVER["DOCUMENT_ROOT"]."/certificates";
	$certdir = "../../certificates";
	$file_list = scandir($certdir);
	$file_list2 = array();
//	$i=0;
	foreach ($file_list as $file_name)
	{
		if (is_file($certdir."/".$file_name) && (substr($file_name, -4)==".cer"))
		{
			$file_content=file_get_contents($certdir."/".$file_name);
//			$file_content="0934287509384j5f234jf5";
			$file_list2[$file_name] = base64_encode($file_content);
//			$file_list2[$i++] = $file_content;
		}
	}
	return $file_list2;
}

$file_list3 = actionGetCertificates();
//var_dump($file_list3);
echo json_encode($file_list3);
?>
