<?php

require_once dirname(__FILE__).'/Vector.php';
require_once dirname(__FILE__).'/GenericObject.php';
require_once dirname(__FILE__).'/SqlParser.php';

/**
 * 
 * @author Marcin
 * CachedObject is used to retrieve data from the memcached
 */
class CachedObject extends GenericObject{
	
	private $cache;
	private $revisionCache;
	
	public function CachedObject(Cache $cache, Cache $revisionCache){
		$this->cache = $cache;
		$this->revisionCache = $revisionCache;
	}
	
	public function get($where, $fields = null) {
		$cacheKey = $this->getCacheKey($where);
		$data = $this->cache->get($cacheKey);
		if(!$data){
			Logger::debug('GET FROM DB');
			$data = parent::get($where, $fields);
			$this->cache->set($cacheKey, $data);
		}else{
			Logger::debug('GET FROM CACHE');
		}
		return $data;
	}
	
	private function getCacheKey($whereString, $readMode = true){

		$baseVector = $this->getBaseVectorFromQuery($whereString, $this->table);
		$vectors = null;
		if($readMode){
			$vectors = $this->makeReadModeChildVectors($baseVector, 0);
		}else{
			$vectors = $this->makeWriteModeChildVectors($baseVector, 0);
		}
		return $this->table.$this->getBigRevision($vectors);
	}
	
	
	
	private function makeReadModeChildVectors(Vector $baseVector, $startIndex){
		$childVectors = array($baseVector);
		foreach ($baseVector->properties as $k => $v){
			if($k >= $startIndex && $v != Vector::ALL && $v != Vector::ANY){
				$newVector = new Vector();
				$newVector->properties = $baseVector->properties;
				$newVector->properties[$k] = Vector::ANY;
				$childVectors = array_merge($childVectors, $this->makeReadModeChildVectors($newVector, $k+1));
			}
		}
		return $childVectors;
	}

	private function makeWriteModeChildVectors(Vector $baseVector, $startIndex){
		$childVectors = array($baseVector);
		foreach ($baseVector->properties as $k => $v){
			if($k >= $startIndex){
				$newVector = new Vector();
				$newVector->properties = $baseVector->properties;
				$newVector->properties[$k] = ($v == Vector::ALL ? Vector::ANY : Vector::ALL);
				$childVectors = array_merge($childVectors, $this->makeWriteModeChildVectors($newVector, $k+1));
			}
		}
		return $childVectors;
	}

	private function getBigRevision($vectors){
		$bigRevision = array();
		foreach ($vectors as $k => $vector){
			$bigRevision []= $this->revisionCache->get($vector.'');
		}
		return '['.implode(',', $bigRevision).']';
	}
	
	public function getBaseVectorFromQuery($whereString, $table, $readMode = true){
		global $config;
		$cacheKeys = @$config['cache_keys_of_table'][$table];
		$parser = new PHPSQLParser('WHERE '.$whereString);
		$result = array();
		$baseVector = new Vector();
		$baseVector->properties = array_fill(0, count($cacheKeys), Vector::ALL);
		$where = $parser->parsed['WHERE'];
		if($where){
			while(list($k, $v) = each($where)){
				if($v['expr_type'] == 'colref'){
					$cacheKeyIndex = array_search($v['base_expr'], $cacheKeys);
					list($k, $operator) = each($where);
					list($k, $value) = each($where);
					if($cacheKeyIndex !== false){
						if($operator['expr_type'] == 'operator'){
							if($operator['base_expr'] == '=' && $value['expr_type'] == 'const'){
								$baseVector->properties[$cacheKeyIndex] = $value['base_expr'];
							}else{
								$baseVector->properties[$cacheKeyIndex] = Vector::ANY;
							}
						}else{
							throw new Exception('QUERY ERROR '.$whereString);
						}
					}
				}else if($v['expr_type'] != 'operator' || $v['base_expr'] != 'AND'){ //TODO => OR operator
					throw new Exception('NO AND IN QUERY '.$whereString);
				}
			}
		}
	
	
		return $baseVector;
	}
	
	public function delete($where) {
		$result = parent::delete($where);
		if($result){
			$this->updateCacheRevision($where);
		}
		return $result;
	}

	private function updateCacheRevision($whereString){
		$baseVector = $this->getBaseVectorFromQuery($whereString, $this->table);
		$vectors = $this->makeWriteModeChildVectors($baseVector, 0);
		$this->revisionCache->inc($vectors);
	}
	
	public function insert($data){
		$result = parent::insert($data);
		if($result){
			$whereString = implode(' AND ', $data);
			$this->updateCacheRevision($whereString);
		}
		return $result;
	}
	
	public function update($data, $where){
		$result = parent::update($data, $where);
		if($result){
			$whereString = implode(' AND ', $data);
			$this->updateCacheRevision($whereString);
			$whereString = implode(' AND ', $where);
			$this->updateCacheRevision($whereString);
		}
		return $result;
	}

}
