<?php 

echo '<div id="contcss"><font color=#076c8e>'.$row['name'].'</font></div>';
?>
<hr style="margin-bottom:-5px;"/>
<table border="1" id="table1">
	<tr>
		<td width="250">
		<table border="1" width="100%" id="table2">
			<tr>
				<td><font  face="Arial" size=3>Телефон:</font></td>
			</tr>
			<tr>
				<td><font  face="Arial"  size=6 color="#313131"><?php echo $row['phone'];?></font></td>
			</tr>
		</table>
		</td>
		<td width="250">
		<table border="1" width="100%" id="table3">
			<tr>
				<td><font  face="Arial" size=3>E-Mail:</font></td>
			</tr>
			<tr>
				<td><font face="Arial" color="#000"><?php echo '<a href="mailto:'.$row['email'].'">'.$row['email'].'</a>';?></font></td>
			</tr>
		</table>
		</td>
		<td width="250">
		<table border="1" width="100%" id="table4">
			<tr>
				<td><font  face="Arial" size=3>Адреса:</font></td>
			</tr>
			<tr>
				<td><?php echo '<h3>'.$row['street'].', '.$row['building'].'</h3>';?></td>
			</tr>
		</table>
		</td>
	</tr>
</table>

<hr style="margin-top:-36px;"/>
<table>
<tr><td style="width: 600px; vertical-align: top;">
<?php



Yii::import('ext.jquery-gmap.*');

$gmap = new EGmap3Widget();
$gmap->setSize(600, 400);

// base options
$options = array(
	'scaleControl' => true,
	'streetViewControl' => false,
	'zoom' => 17,
	'center' => array(0, 0),
	'mapTypeId' => EGmap3MapTypeId::ROADMAP,
	'mapTypeControlOptions' => array(
		'style' => EGmap3MapTypeControlStyle::DROPDOWN_MENU,
		'position' => EGmap3ControlPosition::TOP_CENTER,
	),
);
$gmap->setOptions($options);

// marker with custom icon
$marker = new EGmap3Marker(array(
			'title' => 'Центр надання адміністративних послуг Одеської міської ради',
			'icon' => array(
				'url' => '/images/conference.png',
				'anchor' => array('x' => 1, 'y' => 36),
			//'anchor' => new EGmap3Point(5,5),
			)
		));

// set marker position by address
$marker->address = $row['gpscoordinates'];

// data associated with the marker

// center the map on the marker
$marker->centerOnMap();

$gmap->add($marker);

$gmap->renderMap();
$gmap->setSize(600, 400);
?>




</td>


<td style="vertical-align: top;">


<?

    

      
//if ($row['street']) echo '<b>Адреса:&nbsp;</b><br> '.$row['street'].', '.$row['building'].'<br><br>';

if ($row['working_time']) echo '<h3>Режим роботи:&nbsp;</h3> '.$row['working_time'].'<br><br>';

//if ($row['email']) echo '<b>E-mail:&nbsp;</b><br><a href="mailto:'.$row['email'].'">'.$row['email'].'</a><br><br>';

if ($row['web']) echo '<h3>Веб-сайт:&nbsp;</h3> <a href='.$row['web'].' target=_blank>'.$row['web'].'</a><br><br>';

//if ($row['phone']) echo '<b>Телефон:&nbsp;</b><br> '.$row['phone'].'<br><br>';

if ($row['fax']) echo '<h3><font  face="Arial" color="#313131">Факс:&nbsp;</h3><h1>'.$row['fax'].'</font></h1>';
if ($row['transport']) echo '<h3><font  face="Arial" color="#313131">Міський транспорт:&nbsp;</h3>'.$row['transport'].'</font>';
 
echo "</td></tr></table>";
?>