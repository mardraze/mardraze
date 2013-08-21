<?php 

$config = array();
$config['PORT_GLOBAL_MEMCACHED'] = 15000;
$config['LOG_FILE'] = dirname(__FILE__).'/../log/error.log';
$config['LOG_LEVEL'] = E_ALL;// E_ERROR / E_ALL / E_WARNING / 0
$config['cache_keys_of_table'] = array(
		'songs' => array('song_id', 'author_id'),
		
);

$config['MYSQL'] = array(
		'host' => '127.0.0.1',
		'user' => 'root',
		'password' => '',
		'db' => 'cache_invalidate',
);


mysql_connect($config['MYSQL']['host'], $config['MYSQL']['user'], $config['MYSQL']['password']);

mysql_select_db($config['MYSQL']['db']);
