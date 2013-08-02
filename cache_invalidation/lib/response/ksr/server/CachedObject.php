<?php

require_once 'Vector.php';
require_once 'GenericObject.php';

class CachedObject extends GenericObject{
	
	public function get($where, $fields = null) {
		$query = 'SELECT '.($fields ? $fields : '*').' FROM '.$this->table.($where ? (' WHERE '.$where) : '');
		$result = $this->execute($query);
		$data = array();
		while($row = mysql_fetch_assoc($result)){
			$data[] = $row;
		}
		return $data;
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
