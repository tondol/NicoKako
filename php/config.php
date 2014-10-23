<?php

define('SYSTEM_DIR', dirname(__FILE__) . '/');
define('PUBLIC_DIR', dirname(dirname(__FILE__)) . '/public/');
define('CORE_DIR', SYSTEM_DIR . 'core/');
define('CONTROLLER_DIR', SYSTEM_DIR . 'controller/');
define('TEMPLATE_DIR', SYSTEM_DIR . 'template/');
define('SPYC_DIR', SYSTEM_DIR . 'spyc/');

ini_set('display_errors', true);
ini_set('error_reporting', E_ALL ^ E_NOTICE);
ini_set('include_path', ini_get('include_path') . ':' . CORE_DIR . ':' . SPYC_DIR);
ini_set('date.timezone', "Asia/Tokyo");

require_once 'Spyc.php';

$config = array(
	'controller_dir' => CONTROLLER_DIR,
	'template_dir' => TEMPLATE_DIR,
	'public_dir' => PUBLIC_DIR,

	'application_main' => 'index',
	'application_missing' => 'missing',

	'chain' => array(
		'index' => 'index',
                'live' => 'live',
		'live/video' => 'video',
		'live/delete' => 'delete',
		'live/video/delete' => 'delete',
                'register' => 'register',
		'logs' => 'logs',
		'help' => 'help',
		'missing' => 'missing',
	),
);

$config = array_merge($config, Spyc::YAMLLoad(dirname(SYSTEM_DIR) . '/config.yml'));