<?php

require_once (dirname(__FILE__)).'/server/Cache.php';
require_once (dirname(__FILE__)).'/server/CachedObject.php';

class Server{
	
	private $cache;
	private $revisionCache;
	private $time;
	
	public function Server($port){
		global $config;
		$this->cache = new Cache($port);
		$this->revisionCache = new Cache($config['PORT_GLOBAL_MEMCACHED']);
		$this->time = microtime();
	}

	public function update($table, $set, $where = null){
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		return array(
				'result' => $cachedObject->update($set, $where),
				'execution_time' => $this->getExecutionTime(),
		);
	}
	
	public function insert($table, $set){
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		return array(
				'result' => $cachedObject->insert($set), 
				'execution_time' => $this->getExecutionTime(),
		);
	}
	
	public function delete($table, $where = null){
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		return array(
				'result' => $cachedObject->delete($where), 
				'execution_time' => $this->getExecutionTime(),
		);
	}
	
	public function select($table, $where = null){
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		return array(
				'result' => $cachedObject->get($where), 
				'execution_time' => $this->getExecutionTime(),
		);
	}
	
	private function getExecutionTime(){
		return microtime()-$this->time;
	}
}