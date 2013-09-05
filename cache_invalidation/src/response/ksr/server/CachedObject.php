<?php

require_once dirname(__FILE__).'/Vector.php';
require_once dirname(__FILE__).'/GenericObject.php';

/**
 * 
 * @author Marcin
 * CachedObject is used to retrieve data from the memcache or invalidate cache when write query occured
 */
class CachedObject extends GenericObject{
	
	private $cache;
	private $revisionCache;
	
	public function CachedObject(Cache $cache, Cache $revisionCache){
		$this->cache = $cache;
		$this->revisionCache = $revisionCache;
	}

	public function get($where, $fields = null) {
		$from_cache = false;
		if($this->cache){
			$cacheKey = $this->getCacheKey($where);
			$data = $this->cache->get($cacheKey);
			if($data === false){
				$data = parent::get($where, $fields);
				$this->cache->set($cacheKey, $data);
			}else{
				$from_cache = true;
			}
		}else{
			$data = parent::get($where, $fields);
		}
		return array('data' => $data, 'from_cache' => $from_cache);
	}
	
	private function getCacheKey($whereString){
		$baseVector = $this->getBaseVectorFromQuery($whereString, $this->table);
		$vectors = $this->makeChildVectors($baseVector, 0);
		return $this->table.$this->getBigRevision($vectors);
	}

	private function getBaseVectorFromQuery($whereString, $table){
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
		unset($parser);
		return $baseVector;
	}
	
	private function makeChildVectors(Vector $baseVector, $startIndex){
		$childVectors = array($baseVector);
		foreach ($baseVector->properties as $k => $v){
			if($k >= $startIndex && $v != Vector::ALL){
				$newVector = new Vector();
				$newVector->properties = $baseVector->properties;
				$newVector->properties[$k] = Vector::ALL;
				$childVectors = array_merge($childVectors, $this->makeChildVectors($newVector, $k+1));
			}
		}
		return $childVectors;
	}

	private function getBigRevision($vectors){
		$bigRevision = array();
		
		foreach ($vectors as $k => $v){
			$vector = $v.'';
			$revision = $this->revisionCache->get($vector);
			if($revision === false){
				$this->revisionCache->set($vector, 0);
				$revision = 0;
			}
			$bigRevision []= '('.$vector.','.$revision.')';
		}
		return '['.implode(',', $bigRevision).']';
	}
	public function delete($where) {
		$result = parent::delete($where);
		if($result){
			$this->updateCacheRevision($where);
		}
		return $result;
	}
	
	public function insert($set){
		$result = parent::insert($set);
		if($result){
			$arr = array();
			foreach ($set as $k => $v){
				$arr []= "`$k`='$v'";
			}
			$setString = implode(' AND ', $arr);
			$this->updateCacheRevision($setString);
		}
		return $result;
	}
	
	public function update($set, $where = null){
		$result = parent::update($set, $where);
		if($result){
			$this->updateCacheRevisionBySet($set);
			$this->updateCacheRevision($where);
			unset($arr);
		}
		return $result;
	}
	

	private function updateCacheRevision($whereString){
		if($this->revisionCache){
			$baseVector = $this->getBaseVectorFromQuery($whereString, $this->table);
			$vectors = $this->makeChildVectors($baseVector, 0);
			$this->revisionCache->inc($vectors);
			unset($baseVector);
			unset($vectors);
		}
	}
	
	private function updateCacheRevisionBySet($set){
		$arr = array();
		foreach ($set as $k => $v){
			$arr []= "`$k`='$v'";
		}
		$setString = implode(' AND ', $arr);
		$this->updateCacheRevision($setString);
	}

}
