<?php

class Cache {
	
	private $memcache;
	
	public function Cache($port, $host = null) {
		if(is_null($host)) 
			$host = '127.0.0.1';
		$memcache = new Memcache();
		$memcache->connect($host, $port) or $this->error("Could not connect to memcached at ".$host.':'.$port);
		$this->memcache = $memcache;
	}
	
	public function get(Vector $baseVector){
		$vectors = $this->generateChildVectors($baseVector);
	}
	
	private function generateChildVectors(Vector $baseVector){
		$vector = new Vector();
		//while ()
		
		return $vector;
	}
	
	private function error($msg){
		global $config;
		Logger::error(__CLASS__.' '.$msg);
		throw new Exception($msg, Response::BADREQUEST);
	}
	
	
	
}
