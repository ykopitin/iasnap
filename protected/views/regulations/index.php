<div id="pagetit">Законодавство</div>


<ul>
<?php
$rows=GenRegulations::model()->findAll();  
            
foreach($rows as $row) 
{     
    echo '<li><a href='.$row['hyperlink'].' target=_blank>'.$row['name'].'</a></li>';


}

?>
</ul>