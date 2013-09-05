<?php 
define('CACHE_MODE_NONE', 0);
define('CACHE_MODE_DELETE_ALL_IF_WRITE', 1);
define('CACHE_MODE_ADVANCED', 2);
define('QUERY_TYPE_SELECT', 3);
define('QUERY_TYPE_INSERT', 4);
define('QUERY_TYPE_DELETE', 5);
define('QUERY_TYPE_UPDATE', 6);


$config = array();
$config['PORT_GLOBAL_MEMCACHED'] = 15000; //global cache contain revision numbers for vectors
																					//vector contain revisions for table keys. 
																					// * if 
$config['LOG_FILE'] = dirname(__FILE__).'/../log/error.log';
$config['LOG_LEVEL'] = E_ALL;// E_ERROR / E_ALL / E_WARNING / 0
$config['cache_keys_of_table'] = array(
		'songs' => array('song_id', 'author_id'), //invalidation keys 
);
$config['DEFAULT'] = array(
		'memcached_count' => 3, //count of services with memcache
		'write_query_chance' => 5,//[%] Chance for insert, update or delete query
		'cache_mode' => CACHE_MODE_ADVANCED, //cache invalidation algorithm
		'memcached_port_start' => 11234, //first memcached post, others  
		'table' => 'songs', //mysql table
		'have_chance_percent' => 40, //Random chance for key
		//'test_type' => 'howMuchDataFromCache',
		'test_type' => 'queryDetails', //PerformanceTest method name 
		'write_queries_to_log' => 0, //without select data
		'write_results_to_log' => 0, //huge select data
		'Random_whileMaxCount' => 10,//security - if someone don't have chance 
);

$config['MYSQL'] = array(
		'host' => '127.0.0.1',
		'user' => 'root',
		'password' => '',
		'db' => 'cache_invalidate',
);


mysql_connect($config['MYSQL']['host'], $config['MYSQL']['user'], $config['MYSQL']['password']);

mysql_select_db($config['MYSQL']['db']);
