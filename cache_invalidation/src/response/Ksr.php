<?php

require_once dirname(__FILE__).'/ksr/Server.php';
require_once dirname(__FILE__).'/ksr/lib/PHP-SQL-Parser/php-sql-parser.php';


class Ksr extends Response {

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
			return new Server($port);
		}else{
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