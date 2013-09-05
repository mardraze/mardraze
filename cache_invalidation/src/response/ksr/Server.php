<?php
require_once dirname(__FILE__).'/server/lib/PHP-SQL-Parser/php-sql-parser.php';
require_once dirname(__FILE__).'/server/Cache.php';
require_once dirname(__FILE__).'/server/CachedObject.php';

class Server{
	
	private $cache;
	private $revisionCache;
	
	public function initCache($port){
		global $config;
		$this->cache = new Cache($port);
		$this->revisionCache = new Cache($config['PORT_GLOBAL_MEMCACHED']);
	}

	public function update($table, $set, $where = null){
		$start = microtime(true);
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		$result = array(
				'result' => $cachedObject->update($set, $where),
				'execution_time' => microtime(true)-$start,
		);
		unset($cachedObject);
		return $result;
	}
	
	public function insert($table, $set){
		$start = microtime(true);
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		$result = array(
				'result' => $cachedObject->insert($set), 
				'execution_time' => microtime(true)-$start,
		);
		unset($cachedObject);
		return $result;
	}
	
	public function delete($table, $where = null){
		$start = microtime(true);
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		$result = array(
				'result' => $cachedObject->delete($where), 
				'execution_time' => microtime(true)-$start,
		);
		unset($cachedObject);
		return $result;
	}
	
	public function select($table, $where = null){
		$start = microtime(true);
		$cachedObject = new CachedObject($this->cache, $this->revisionCache);
		$cachedObject->table = $table;
		$result = array(
				'result' => $cachedObject->get($where), 
				'execution_time' => microtime(true)-$start,
		);
		unset($cachedObject);
		return $result;
	}
	
	private function getMicrotime(){
		
	}
	
	function __destruct(){
		unset($this->cache);
		unset($this->revisionCache);
	}
	
}