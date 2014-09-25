<?php

// Prevent caching.
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 01 Jan 1996 00:00:00 GMT');

// The JSON standard MIME header.
header('Content-type: application/json');

// Get client ask to generate string
$ask = $_POST['ask'];
// Client must specify codephrase
if (base64_decode($ask, true) != "GetCertificate")
  return;
// Generating random auth string with length 40. This value also specified in files:
// classes/modules/users/ class.php, __register.php
// If this value changing, it need to be changed in all files
//$randstr=randomText(40,'string','int','symbol');

$cert = file_get_contents('cnapcert.cer');
$cert = base64_encode($cert);
$arr = array('cert' => $cert);
echo json_encode($arr);
?>
