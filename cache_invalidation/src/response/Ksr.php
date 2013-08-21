<?php

require_once dirname(__FILE__).'/ksr/Server.php';
require_once dirname(__FILE__).'/ksr/lib/PHP-SQL-Parser/php-sql-parser.php';


class Ksr extends Response {

	public function executeDelete(){
		if(!@$_REQUEST['query']){
			throw new Exception('GET[query] must be specified', self::BADREQUEST);
		}
		if(!@$_REQUEST['query']['table']){
			throw new Exception('GET[query][table] must be specified', self::BADREQUEST);
		}
		if(!@$_REQUEST['query']['set']){
			throw new Exception('GET[query][set] must be specified', self::BADREQUEST);
		}
		
		$server = $this->initServer();
		$time = microtime();
		$this->content = $server->select($_REQUEST['query']['table'], @$_REQUEST['query']['where']);
		Logger::debug("MICROTIME: ".(microtime()-$time));
	}

	public function executeSelect(){
		if(!@$_REQUEST['query']){
			throw new Exception('GET[query] must be specified', self::BADREQUEST);
		}
		if(!@$_REQUEST['query']['table']){
			throw new Exception('GET[query][table] must be specified', self::BADREQUEST);
		}
		
		$server = $this->initServer();
		$time = microtime();
		$this->content = $server->select($_REQUEST['query']['table'], @$_REQUEST['query']['where']);
		Logger::debug("MICROTIME: ".(microtime()-$time));
	}
	
	private function initServer(){
		$port = @$_REQUEST['port'];
		if($port > 10000){
			return new Server($port);
		}else{
			throw new Exception('GET[port] => "'.$port.'" is wrong, may be > 10000');
		}
	}
	
}