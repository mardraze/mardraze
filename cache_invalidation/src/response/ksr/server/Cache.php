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

	public function get($key){
		return $this->memcache->get($key);
	}
	
	public function set($key, $value){
		return $this->memcache->set($key, $value);
	}
	
	public function inc($keys){
		foreach ($keys as $k => $v){
			$key = $v.'';
			$exists = $this->memcache->increment($key);
			if($exists === false){
				$value = $this->memcache->set($key, 0);
			}
		}
	}
	
	private function error($msg){
		global $config;
		Logger::error(__CLASS__.' '.$msg);
		throw new Exception($msg, Response::BADREQUEST);
	}
	
	function __destruct(){
		$this->memcache->close();
		unset($this->memcache);
	}

}
