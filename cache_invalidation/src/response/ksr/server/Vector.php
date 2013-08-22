<?php

class Vector{
	const ALL = '*'; 
	
	public $properties = array();
	
	public function __toString(){
		return '('.implode(',', $this->properties).')';
	}

}
