<?php

class Vector{
	const ANY = '?'; 
	const ALL = '*'; 
	
	public $properties = array();

	
	public function __toString(){
		return '('.implode(',', $this->properties).')';
	}
	
	public function init($table, $where){
		
	}

}
