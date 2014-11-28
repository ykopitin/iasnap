
<div id="pagetit">Контакти центрів</div>
<div id="concen">
<table>
<tr><td colspan="2">
<?php
$rows=GenAuthorities::model()->findAllByAttributes(array('is_cnap'=>'ЦНАП'));  
           
foreach($rows as $row) 
{ 
echo '<h3><font color=#076c8e>'.$row['name'].'</font></h3>';
?>
</td></tr>

<tr><td colspan="2">
<hr />
<table><tr><td style="width: 300px;">
<p><font  face="Arial" size=3>Телефон:</font></p>
<p><font  face="Arial"  size=6 color="#313131"><?php echo $row['phone'];?></font></p>
</td><td  style="width: 300px;">

<p><font  face="Arial" size=3>E-Mail:</font></p>
<p><font face="Arial" color="#000"><?php echo '<a href="mailto:'.$row['email'].'">'.$row['email'].'</a>';?></font></p>
</td><td  style="width: 300px;">

<p><font  face="Arial" size=3>Адреса:</font></p>
<?php echo '<h3>'.$row['street'].', '.$row['building'].'</h3>';?>
</td></tr></table>
<hr />
</td></tr>

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
$marker->data = 'test data !';

// add a Javascript event on marker click
$js = "function(marker, event, data){
        var map = $(this).gmap3('get'),
        infowindow = $(this).gmap3({action:'get', name:'infowindow'});
        if (infowindow){
            infowindow.open(map, marker);
            infowindow.setContent(data);
        } else {
            $(this).gmap3({action:'addinfowindow', anchor:marker, options:{content: data}});
        }
}";
$marker->addEvent('click', $js);

// center the map on the marker
$marker->centerOnMap();

$gmap->add($marker);

$gmap->renderMap();

?>




</td>


<td style="vertical-align: top;">


<?php

    

      
//if ($row['street']) echo '<b>Адреса:&nbsp;</b><br> '.$row['street'].', '.$row['building'].'<br><br>';

if ($row['working_time']) echo '<h3>Режим роботи:&nbsp;</h3> '.$row['working_time'].'<br>';

//if ($row['email']) echo '<b>E-mail:&nbsp;</b><br><a href="mailto:'.$row['email'].'">'.$row['email'].'</a><br><br>';

if ($row['web']) echo '<h3>Веб-сайт:&nbsp;</h3> <a href='.$row['web'].' target=_blanck>'.$row['web'].'</a><br><br>';

//if ($row['phone']) echo '<b>Телефон:&nbsp;</b><br> '.$row['phone'].'<br><br>';

if ($row['fax']) echo '<h3><font  face="Arial" color="#313131">Факс:&nbsp;</h3><h1>'.$row['fax'].'</font></h1>';
 

}



?>


</td></tr></table></div>
