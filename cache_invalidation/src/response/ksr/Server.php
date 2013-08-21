<?php

require_once (dirname(__FILE__)).'/server/Cache.php';
require_once (dirname(__FILE__)).'/server/CachedObject.php';

class Server{
	
	private $cache;
	private $revisionCache;
	
	public function Server($port){
		global $config;
		$this->cache = new Cache($port);
		$this->revisionCache = new Cache($config['PORT_GLOBAL_MEMCACHED']);
	}
	
	public function select($table, $where = null){
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		return $cachedObject->get($where);
	}
	
}