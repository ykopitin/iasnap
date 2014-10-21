<!--<applet codebase="http://sign.eu.iit.com.ua"
	code="com.iit.certificateAuthority.endUser.libraries.signJava.EndUser.class"
	cache_archive="Java.jar"
	cache_version="1.3.51"
	archive="EUSignJava.jar"
	id="euSign_<?= $data->name ?>"
	width="1"
	height="1"
        />-->
<?php
$this->Widget('application.components.EUWidget.EUWidget', array('WidgetType'=>'Hidden'));
