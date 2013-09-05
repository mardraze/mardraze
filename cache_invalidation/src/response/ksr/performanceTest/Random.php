<?php
class Random {

	private $typeWrite = array(
			QUERY_TYPE_INSERT, 
			QUERY_TYPE_DELETE, 
			QUERY_TYPE_UPDATE 
	);
	
	public function queryType($writeQueryChance){
		$percent = $this->getRandomValue();
		if($percent >= $writeQueryChance){
			return QUERY_TYPE_SELECT;
		}else{
			return $this->typeWrite[$percent % 3];
		}
	}
	
	public function paramSet($table){
		global $config;
		if(!@$config['cache_keys_of_table'][$table]) throw new Exception('TABLE MUST BE SET IN $config[cache_keys_of_table]');
		$set = array();
		foreach ($config['cache_keys_of_table'][$table] as $k => $property){
			$set[$property] = $this->getRandomValue();
		}
		return $set;
	}
	
	public function paramWhere($table, $minKeysCount = null){
		global $config;
		if(!@$config['cache_keys_of_table'][$table]) throw new Exception('TABLE MUST BE SET IN $config[cache_keys_of_table]');
		if(!$minKeysCount){
			$minKeysCount = 1;
		}
		$where = array();
		$keysCount = 0;
		$whileMaxCount = 0;
		while($keysCount < $minKeysCount || $whileMaxCount >= $config['DEFAULT']['Random_whileMaxCount']){
			foreach ($config['cache_keys_of_table'][$table] as $k => $property){
				if($this->haveChance()){
					$keysCount++;
					$where[] = '`'.$property.'`="'.$this->getRandomValue().'"';
				}
			}
		}
		return implode(' AND ', $where);
	}
	
	private function getRandomValue(){
		$rand = rand();
		return ($rand%100)+1;
	}
	
	private function haveChance(){
		global $config;
		return $this->getRandomValue() <= $config['DEFAULT']['have_chance_percent'];
	}
}
