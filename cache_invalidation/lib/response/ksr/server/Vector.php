<?php

class Vector{
	const ANY = '?'; 
	const ALL = '*'; 
	
	public $properties = array();

	
	public function __toString(){
		return '('.implode(',', $this->properties).')';
	}
	
	public function init($table, $where){
		global $config;
		
		$cache_keys_of_table = @$config['cache_keys_of_table'][$table];
		
		
		
		foreach (@$cache_keys_of_table as $index => $cache_key){
			if(array_key_exists($cache_key, $where)){
				if(is_numeric($where[$cache_key])){
					//$this->properties[$k] = 
				}
				//$cache_keys_of_table
			}
		}
		
	}
	
}
