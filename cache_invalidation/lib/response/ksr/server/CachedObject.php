<?php

require_once 'Vector.php';
require_once 'GenericObject.php';
/**
 * 
 * @author Marcin
 * CachedObject is used to retrieve data from the memcached
 */
class CachedObject extends GenericObject{
	
	private $cache;
	
	public function CachedObject(Cache $cache){
		$this->cache = $cache;
	}
	
	public function get($where, $fields = null) {
		global $config;
		$data = $this->getFromCache($where, $fields);
		if(!$data){
			$data = parent::get($where, $fields);
		}
		return $data;
	}
	
	private function getFromCache($whereString, $fields = null){
		$baseVector = new Vector();
		$baseVector->properties = $this->parseWhere($whereString);
		$vectors = $this->makeChildVectors($baseVector);
		$bigRevision = $this->getBigRevision($vectors);
		return $this->cache->get($this->table.$bigRevision);
	}
	
	private function parseWhere($whereString){
		global $config;
		$cacheKeysFromWhere = array();
		$cache_keys_of_table = @$config['cache_keys_of_table'][$table];
		foreach (@$cache_keys_of_table as $index => $cache_key){
			if(array_key_exists($cache_key, $where)){
				
			}
		}		
		return $cacheKeysFromWhere;
	}
	
	private function makeBaseVector($where, $fields = null){
		global $config;
		
		$cache_keys_of_table = @$config['cache_keys_of_table'][$table];
		$baseVector = new Vector();
		foreach (@$cache_keys_of_table as $index => $cache_key){
			if(array_key_exists($cache_key, $where)){
				
			}
		}
		return $baseVector;
	}

	private function makeChildVectors(Vector $baseVector){
		$childVectors = array();
		return $childVectors;
	}

	private function getBigRevision($vectors){
		
	}
	
	public function delete($where) {
		$query = 'DELETE FROM '.$this->table.($where ? (' WHERE '.$where) : '');
		$this->execute($query);
	}

	protected function insert($data){
		$set = array();
		foreach($data as $k => $v){
			$set[] = '`'.$k.'`="'.$v.'"';
		}
		$query = 'INSERT INTO '.$this->table.' SET '.implode(',', $set);
		$this->execute($query);
		return mysql_insert_id();
	}
	
	protected function update($data, $where){
		$set = array();
		foreach($data as $k => $v){
			$set[] = '`'.$k.'`="'.$v.'"';
		}
		$query = 'UPDATE '.$this->table.' SET '.implode(',', $set).' WHERE '.$where;
		$this->execute($query);
	}

}
