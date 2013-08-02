<?php

require_once (dirname(__FILE__)).'/server/Cache.php';
require_once (dirname(__FILE__)).'/server/CachedObject.php';

class Server{
	
	private $cache;
	
	public function Server($server){
		if(@$server['port'] < 10000) 
			throw new Exception('MEMCACHED PORT HAVE TO BE > 10000, PARAM: server["port"]', Response::BADREQUEST);
		$this->cache = new Cache($server['port']);
	}
	
	public function select($query){
		$cachedObject = new CachedObject();
		$cachedObject->table = $query['table'];
		return $cachedObject->get(@$query['where']);
	}
	
}