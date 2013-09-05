<?php

require_once dirname(__FILE__).'/ksr/Server.php';
require_once dirname(__FILE__).'/ksr/PerformanceTest.php';

class Ksr extends Response {

	
	/////////////////////////////////////////// Performance test - multiple query  ///////////////////
	
	public function executePerformanceTest(){
		$start = microtime(true);
		$configuration = $this->overwriteConfigurationFromRequest();
		$servers = $this->initServers($configuration);
		$testType = $configuration['test_type'];
		$pt = new PerformanceTest($servers, $configuration);
		$this->content = array(
			'result' => $pt->$testType(),
			'execution_time' => microtime(true)-$start,
		);
	}
	
	private function initServers($configuration){
		$cacheMode = $configuration['cache_mode'];
		$memcachedPortStart = $configuration['memcached_port_start'];
		$memcachedCount = $configuration['memcached_count'];
		$servers = new stdClass();
		for($i=0; $i<$memcachedCount; $i++){
			$server = new Server();
			switch ($cacheMode){
				//zaawansowany algorytm inwalidacji
				case CACHE_MODE_ADVANCED : $server->initCache($memcachedPortStart + $i); break;
				default:
			}
			$key = 'server'.$i;
			$servers->$key = $server;
		}
		return $servers;
	}
	
	private function overwriteConfigurationFromRequest(){
		global $config;
		$configParameters = array();
		foreach ($config['DEFAULT'] as $key => $value){
			if(array_key_exists($key, $_REQUEST)){
				$configParameters[$key] = $_REQUEST[$key];
			}else{
				$configParameters[$key] = $value;
			}
		}
		return $configParameters;
	}
	
	
	
	
	
	
	
	//////////////////////////////////////// One query test ///////////////////////////////////////////////
	
	public function executeUpdate(){
		$this->requestQueryShouldHaveKeys('table', 'set');
		$server = $this->initServer();
		$this->content = $server->update($_REQUEST['query']['table'], $_REQUEST['query']['set'], @$_REQUEST['query']['where']);
	}
	
	public function executeInsert(){
		$this->requestQueryShouldHaveKeys('table', 'set');
		$server = $this->initServer();
		$this->content = $server->insert($_REQUEST['query']['table'], $_REQUEST['query']['set']);
	}
	
	public function executeDelete(){
		$this->requestQueryShouldHaveKeys('table');
		$server = $this->initServer();
		$this->content = $server->delete($_REQUEST['query']['table'], @$_REQUEST['query']['where']);
	}

	public function executeSelect(){
		$this->requestQueryShouldHaveKeys('table');
		$server = $this->initServer();
		$this->content = $server->select($_REQUEST['query']['table'], @$_REQUEST['query']['where']);
	}
	
	private function initServer(){
		$port = @$_REQUEST['port'];
		if($port > 10000){
			$server = new Server();
			$server->initCache($port);
			return $server;
		} else {
			throw new Exception('GET[port] => "'.$port.'" is wrong, may be > 10000');
		}
	}
	
	private function requestQueryShouldHaveKeys(){
		$args = func_get_args();
		if(!array_key_exists('query', $_REQUEST)){
			throw new Exception("GET[query] must be specified", self::BADREQUEST);
		}
		foreach ($args as $key){
			if(!array_key_exists($key, $_REQUEST['query'])){
				throw new Exception("GET[query][$key] must be specified", self::BADREQUEST);
			}
		}
	}
	
}