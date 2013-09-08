<?php

require_once dirname(__FILE__).'/performanceTest/Random.php';

class PerformanceTest {
	
	private $serverCount;
	private $configuration;
	
	public function PerformanceTest($servers, $configuration){
		$this->servers = $servers;
		$this->configuration = $configuration;
	}
	
	//default test
	public function __call($method, $args){
		return $this->howMuchDataFromCache(); 
	}
	/**
	  [
		  ['Ilość żądań', 'Procent danych pobranych z cache'],
			['1000',           xx],
			['2000',           xx],
			['4000',           xx],
			['8000',           xx]
		]
	 		@param array $table
	 */
	public function howMuchDataFromCache(){
		$data = array();
		$data[] = array('Ilość wszystkich zapytań', 'Ilość zapytań pobranych z cache', 'Średni czas wykonania zapytania');
		$queriesCount = array(3);
		$serverCount = $this->configuration['memcached_count'];
		$log = array();
		foreach ($queriesCount as $count){
			$fromCache = 0;
			$timeSum = 0.0;
			$max = $count * $serverCount;
			for($j=0; $j<$count; $j++){
				for($i=0; $i < $serverCount; $i++){
					$key = 'server'.$i;
					$server = $this->servers->$key;
					$result = $this->makeQueryAndGetResult($server);
					if($this->configuration['write_queries_to_log']){
						$log[] = $result['query'];
					}
					if(is_array($result['data']['result']) && array_key_exists('from_cache', $result['data']['result']) && $result['data']['result']['from_cache']){
						$fromCache++;
					}
					$timeSum += $result['data']['execution_time'];
					unset($result);
				}
			}
			$data[] = array($max, $fromCache, $timeSum/$max);
		}
		$ret = array('data' => $data, 'log' => $log);
		unset($data);
		unset($log);
		return $ret;
	}
	
	public function queryDetails(){
		$data = array();
		$data[] = array('Lp', 'Select From Cache', 'Select From DB', 'Insert', 'Delete', 'Update');
		$queriesCount = array(10);
		$serverCount = $this->configuration['memcached_count'];
		$log = array();
		$queryType2Index = array(
				'select' => 2,
				'insert' => 3,
				'delete' => 4,
				'update' => 5,
		);
		foreach ($queriesCount as $count){
			for($j=0; $j<$count; $j++){
				for($i=0; $i < $serverCount; $i++){
					$key = 'server'.$i;
					$server = $this->servers->$key;
					$result = $this->makeQueryAndGetResult($server);
					$fromCache = false;
					if(is_array($result['data']['result']) && array_key_exists('from_cache', $result['data']['result']) && $result['data']['result']['from_cache']){
						$index = 1;
						$fromCache = true;
					}else{
						$index = $queryType2Index[$result['query']['type']];
					}
					if($this->configuration['write_queries_to_log']){
						$log[] = $this->makeLog($result, $fromCache);
					}
					if($this->configuration['write_results_to_log']){
						$log[] = $result;
					}
					$array = 	array_fill(0, 6, 0);
					$array[0] = count($data);
					$array[$index] = $result['data']['execution_time'];
					$data[] = $array;
					unset($result);
				}
			}
		}
		$ret = array('data' => $data, 'log' => $log);
		unset($data);
		unset($log);
		return $ret;
	}
	
	private function makeLog($result, $fromCache){
		return array(
				'query' => $result['query'],
				'time' => $result['data']['execution_time'],
				'from_cache' => $fromCache,
		);
	}
	
	private function makeQueryAndGetResult(Server $server){
		$table = $this->configuration['table'];
		$random = new Random();
		$queryType = $random->queryType($this->configuration['write_query_chance']);
		$result = array();
		switch ($queryType){
			case QUERY_TYPE_SELECT :
				$where = $random->paramWhere($table, 0);
				$result = array(
					'query' => array(
							'type' => 'select',
							'where' => $where
					),
					'data' => $server->select($table, $where)
				);
				break;
			case QUERY_TYPE_INSERT :
				$set = $random->paramSet($table);
				$result = array(
					'query' => array(
							'type' => 'insert',
							'set' => $set
					),
					'data' => $server->insert($table, $set)
				);
				break;
			case QUERY_TYPE_DELETE :
				$where = $random->paramWhere($table, 1);
				$result = array(
					'query' => array(
							'type' => 'delete',
							'where' => $where
					),
				//	'data' => $server->delete($table, $where)
					'data' => $server->update($table, $where, $where)
				);
				break;
			case QUERY_TYPE_UPDATE :
				$set = $random->paramSet($table);
				$where = $random->paramWhere($table, 1);
				$result = array(
					'query' => array(
							'type' => 'update',
							'set' => $set,
							'where' => $where
					),
					'data' => $server->update($table, $set, $where)
				);
				break;
			default:
				throw new Exception('Unknown type', 500);
		}
		unset($random);
		return $result;
	}
	
}
