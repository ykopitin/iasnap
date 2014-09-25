<?php
function randomText()
{
    //Получаем аргументы
    $args_ar = func_get_args();
    $new_arr = array();
 
    //Определяем длину текста
    $length = $args_ar[0];
    unset($args_ar[0]);
 
    if(!sizeof($args_ar))
    {
        $args_ar = array("string","int","symbol");
    }
 
    $arr['string'] = array(
         'a','b','c','d','e','f',
         'g','h','i','j','k','l',
         'm','n','o','p','r','s',
         't','u','v','x','y','z',
         'A','B','C','D','E','F',
         'G','H','I','J','K','L',
         'M','N','O','P','R','S',
         'T','U','V','X','Y','Z');
 
    $arr['int'] = array(
         '1','2','3','4','5','6',
         '7','8','9','0');
 
    $arr['symbol'] = array(
         '.','$','[',']','!','@',
         '*', '+','-','{','}');
 
    //Создаем массив из всех массивов
    foreach($args_ar as $type)
    {
        if(isset($arr[$type]))
        {
            $new_arr = array_merge($new_arr,$arr[$type]);
        }
    }
 
    // Генерируем строку
    $str = "";
    for($i = 0; $i < $length; $i++)
    {
        // Вычисляем случайный индекс массива
        $index = rand(0, count($new_arr) - 1);
        $str .= $new_arr[$index];
    }
    return $str;
}

// Prevent caching.
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 01 Jan 1996 00:00:00 GMT');

// The JSON standard MIME header.
header('Content-type: application/json');

// This ID parameter is sent by our javascript client.
//$id = $_GET['id'];

// Here's some data that we want to send via JSON.
// We'll include the $id parameter so that we
// can show that it has been passed in correctly.
// You can send whatever data you like.
//$data = array("Hello", $id);

// Send the data.
//echo json_encode($data);

// Get client ask to generate string
$ask = $_POST['ask'];
// Client must specify codephrase
if (base64_decode($ask, true) != "GenerateAuthString")
  return;
// Generating random auth string with length 40. This value also specified in files:
// classes/modules/users/ class.php, __register.php
// If this value changing, it need to be changed in all files
$randstr=randomText(40,'string','int','symbol');

// Todo: include db connect
$db = "cnap";
$link = mysql_connect('localhost', 'cnap', 'SyUwuiIQe931') OR die(mysql_error());
mysql_select_db ( $db, $link ) or die ("Невозможно открыть $db");
$query = "INSERT INTO user_gen_str (sauth, itime) VALUES ('" . mysql_real_escape_string($randstr) . "', '" . time() . "');";
mysql_query ( $query, $link );

//$result = mysql_query("SELECT sauth FROM authstrings;", $link)
//    or die("Invalid query: " . mysql_error());
//while($f=mysql_fetch_assoc($result))
//{
//  echo($f['sauth'] . " " . $f['itime']);
//}

mysql_close ( $link );

$arr = array('randstr' => $randstr);
//$bb = base64_encode($a);
//$bb = base64_encode($aa);
echo json_encode($arr);
?>
