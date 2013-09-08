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
	
	public function CachedObject(Cache $cache = null, Cache $revisionCache = null){
		$this->cache = $cache;
		$this->revisionCache = $revisionCache;
	}

	public function get($where, $fields = null) {
		$from_cache = false;
		if($this->cache){
			$cacheKey = $this->getCacheKey($where);
			$data = $this->cache->get($cacheKey);
			if($data === false){
				$whereString = (is_array($where) ? $this->kvArray2String($where) : $where);
				$data = parent::get($whereString, $fields);
				$this->cache->set($cacheKey, $data);
			}else{
				$from_cache = true;
			}
		}else{
			$whereString = (is_array($where) ? $this->kvArray2String($where) : $where);
			$data = parent::get($whereString, $fields);
		}
		return array('data' => $data, 'from_cache' => $from_cache);
	}
	
	private function getCacheKey($where){
		$baseVector = $this->getBaseVectorFromQuery($where, $this->table);
		$vectors = $this->makeChildVectors($baseVector, 0);
		return $this->table.$this->getBigRevision($vectors);
	}

	private function getBaseVectorFromQuery($whereParam, $table){
		global $config;
		if(!array_key_exists($table, $config['cache_keys_of_table'])) 
			throw new Exception('TABLE "'.$table.'" MUST BE IN config', 500);
		$cacheKeys = @$config['cache_keys_of_table'][$table];

		$result = array();
		$baseVector = new Vector();
		$baseVector->properties = array_fill(0, count($cacheKeys), Vector::ALL);
		$where = null;
		if(is_array($whereParam)){
			$where = $whereParam;
			while(list($k, $v) = each($where)){
				$cacheKeyIndex = array_search($k, $cacheKeys);
				if($cacheKeyIndex !== false){
					$baseVector->properties[$cacheKeyIndex] = $v;
				}
			}
		}else{
			$parser = new PHPSQLParser('WHERE '.$whereParam);
			$where = $parser->parsed['WHERE'];
			unset($parser);
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
								throw new Exception('QUERY ERROR '.$whereParam);
							}
						}
					}else if($v['expr_type'] != 'operator' || $v['base_expr'] != 'AND'){ //TODO => OR operator
						throw new Exception('NO AND IN QUERY '.$whereParam);
					}
				}
			}
		}
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
		$result = (is_array($where) ? (parent::delete($this->kvArray2String($where))) : parent::delete($where));
		if($result){
			$this->updateCacheRevision($where);
		}
		return $result;
	}

	public function insert($set){
		$result = parent::insert($set);
		if($result){
			$this->updateCacheRevision($set);
		}
		return $result;
	}

	public function update($set, $where = null){
		$result = (is_array($where) ? (parent::update($set, $this->kvArray2String($where))) : parent::update($set, $where));
		if($result){
			$this->updateCacheRevision($set);
			$this->updateCacheRevision($where);
			unset($arr);
		}
		return $result;
	}

	private function updateCacheRevision($whereParam){
		if($this->revisionCache){
			$baseVector = $this->getBaseVectorFromQuery($whereParam, $this->table);
			$vectors = $this->makeChildVectors($baseVector, 0);
			$this->revisionCache->inc($vectors);
			unset($baseVector);
			unset($vectors);
		}
	}

	private function kvArray2String($array){
		$arr = array();
		foreach ($array as $k => $v){
			$arr []= "`$k`=$v";
		}
		$arrString = implode(' AND ', $arr);
		unset($arr);
		return $arrString;
	}
}
