<?php
require dirname(__FILE__).'/Response.php';
require dirname(__FILE__).'/Request.php';

class RestRouting{

	public function execute(){
		$uri = $this->parseUri();
		$className = ucfirst(@$uri[0].'');
		$method = 'execute'.(@$uri[1] ? ucfirst($uri[1]) : 'Default');
		$path = dirname(__FILE__).'/response/'.$className.'.php';
		if(!file_exists($path)){ 
			$className = 'Response'; //default class
			$path = 'Response.php';
		}
		include_once($path);
		return $this->callMethodOfClass($className, $method, $uri);
	}
	
	private function callMethodOfClass($className, $method, $uri){
		$r = new ReflectionClass($className);
		$objInstance = $r->newInstanceArgs(array());
		$objInstance->initRequest($uri);
		$objInstance->preExecute();
		call_user_func(array($objInstance, $method));
		$objInstance->postExecute();
		return $objInstance->getResult();
	}
	
	private function parseUri(){
		if (isset($_SERVER['REDIRECT_URL']) && isset($_SERVER['SCRIPT_NAME'])) { // use redirection URL from Apache environment
			$dirname = dirname($_SERVER['SCRIPT_NAME']);
			$uri = substr($_SERVER['REDIRECT_URL'], strlen($dirname == DIRECTORY_SEPARATOR ? '' : $dirname));
		} elseif (isset($_SERVER['REQUEST_URI'])) { // use request URI from environment
			$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
		} elseif (isset($_SERVER['PHP_SELF']) && isset($_SERVER['SCRIPT_NAME'])) { // use PHP_SELF from Apache environment
			$uri = substr($_SERVER['PHP_SELF'], strlen($_SERVER['SCRIPT_NAME']));
		} else { // fail
			$uri = '';
		}
		$uri = explode('/', $uri);
		array_shift($uri); //remove first empty
		return $uri;
	}
}
