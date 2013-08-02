<?php

class Logger{

	public static function error($msg){
		self::write('[ERROR] '.$msg, E_ERROR);
	}
	
	public static function warning($msg){
		self::write('[WARNING] '.$msg, E_WARNING);
	}
	
	public static function debug($msg){
		self::write('[DEBUG] '.$msg, -1);
	}
	
	private static function write($msg, $level){
		global $config;
		if($config['LOG_LEVEL'] & $level){
			$h = fopen($config['LOG_FILE'], 'a+');
			fwrite($h, date("Y-m-d H:i:s").' '.$msg."\n");
			fclose($h);
		}
	}
	
}