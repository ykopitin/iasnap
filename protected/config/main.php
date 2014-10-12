<?php

// uncomment the following to define a path alias
// Yii::setPathOfAlias('local','path/to/local-folder');

// This is the main Web application configuration. Any writable
// CWebApplication properties can be configured here.
return array(
	'basePath'=>dirname(__FILE__).DIRECTORY_SEPARATOR.'..',
	'name'=>'Інформаційно-аналітична система надання адміністративних послуг',
        'sourceLanguage'=>'en',
        'language'=>'uk',
	// preloading 'log' component
        'preload'=>array('log'),

	// autoloading model and component classes
	'import'=>array(
		'application.models.*',
		'application.components.*',
	),

	'modules'=>array(
		// uncomment the following to enable the Gii tool
		'admin',
		'gii'=>array(
			'class'=>'system.gii.GiiModule',
			'password'=>'iasnap',
			// If removed, Gii defaults to localhost only. Edit carefully to taste.
			'ipFilters'=>array($_SERVER['REMOTE_ADDR']),
		),
                'mff'=>array( // Модуль свободных форм
//                    'enableprotected'=>FALSE, // Игнорирование защиты системных данных в свободных формах (нужно для отладки)
                )
		/**/
	),

	// application components
	'components'=>array(
		'user'=>array(
//			'loginUrl'=>array('accounts/login'),
			// enable cookie-based authentication
			'allowAutoLogin'=>true,
		),
		// uncomment the following to enable URLs in path-format
		
		'urlManager'=>array(
                        'baseUrl'=>'',
			'urlFormat'=>'path',
			'rules'=>array(
				'1'=>'site/contact',
				'<controller:\w+>/<id:\d+>'=>'<controller>/view',
				'<controller:\w+>/<action:\w+>/<id:\d+>'=>'<controller>/<action>',
				'<controller:\w+>/<action:\w+>'=>'<controller>/<action>',
			),
		),
		
		/*
		'db'=>array(
			'connectionString' => 'sqlite:'.dirname(__FILE__).'/../data/testdrive.db',
		),
		// uncomment the following to use a MySQL database
		*/
		'db'=>array(
			'connectionString' => 'mysql:host=localhost;dbname=cnap_portal',
			'emulatePrepare' => true,
			'username' => 'iasnap',
			'password' => 'iasnap98',
			'charset' => 'utf8',
//                    'enableProfiling'=>true, // показываем значения параметров 
//                    'enableParamLogging' => true, 
		),
		/**/
		'errorHandler'=>array(
			// use 'site/error' action to display errors
			'errorAction'=>'site/error',
		),
//		'log'=>array(
//			'class'=>'CLogRouter',
//			'routes'=>array(
//				array(
//					'class'=>'CFileLogRoute',                                       
//					'levels'=>'error, warning, trace, log, vardump',
//				),
//                                array(
//                                        'class'=>'CProfileLogRoute',
//                                        'levels' => 'error, warning, trace, profile, info',
//                                        'report'=>'callstack',
//                                        'enabled'=>true,
//                                ),				
//                                array(
//					'class'=>'CWebLogRoute',
//                                        'enabled' => true,
//                                        'levels' => 'error, warning, trace, notice',
//                                        'categories' => 'application',
//                                        'showInFireBug' => false,
//				),
//				
//			),
//		),
	),

	// application-level parameters that can be accessed
	// using Yii::app()->params['paramName']
	'params'=>array(
		// this is used in contact page
		'adminEmail'=>'webmaster@example.com',
	),
);
