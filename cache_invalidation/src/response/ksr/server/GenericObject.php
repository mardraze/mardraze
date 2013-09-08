<?php
/**
 * 
 * @author Marcin
 * GenericObject is used to retrieve data from the database
 */
class GenericObject {

	public $table;

	public function save($data, $where = null) {
		if($where) return $this->update($data, $where);
		else return $this->insert($data);
	}
	
	public function get($where, $fields = null) {
		$where = $this->kvArray2String($where);
		$query = 'SELECT '.($fields ? $fields : '*').' FROM '.$this->table.($where ? (' WHERE '.$where) : '');
		$result = $this->execute($query);
		$data = array();
		while($row = mysql_fetch_assoc($result)){
			$data[] = $row;
		}
		mysql_free_result($result);
		return $data;
	}

	public function delete($where) {
		$where = $this->kvArray2String($where);
		$query = 'DELETE FROM '.$this->table.($where ? (' WHERE '.$where) : '');
		$this->execute($query);
		return mysql_affected_rows();
	}


	protected function insert($data){
		$set = $this->kvArray2String($data, ',');
		$query = 'INSERT INTO '.$this->table.' SET '. $set;
		$this->execute($query);
		return mysql_insert_id();
	}
	
	protected function update($data, $where){
		$set = $this->kvArray2String($data, ',');
		$query = 'UPDATE '.$this->table.' SET '. $set .($where ? (' WHERE '.$where) : '');
		$this->execute($query);
		return mysql_affected_rows();
	}
	
	protected function execute($query){
		$result = mysql_query($query) or $this->error($query.' '.mysql_error());
		return $result;
	}
	
	protected function error($query){
		die($query);
	}
	
	private function kvArray2String($array, $glue = null){
		if(is_array($array)){
			if(!$glue){
				$glue = ' AND ';
			}
			$arr = array();
			foreach ($array as $k => $v){
				$arr []= "`$k`=$v";
			}
			$arrString = implode($glue, $arr);
			unset($arr);
			return $arrString;
		}else{
			return $array;
		}
	}
}
