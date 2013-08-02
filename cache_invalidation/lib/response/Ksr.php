<?php

require_once (dirname(__FILE__)).'/ksr/Server.php';

class Ksr extends Response{
	
	public function executeCreateServer(){
		$serverConfig = @$_REQUEST['server'];
		if($serverConfig['id']){
			$server = new Server($serverConfig);
			$_SESSION['server_'.$serverConfig['id']] = $serverConfig;
			$this->content = 'created';
		}else{
			throw new Exception('need server[id] param',Response::BADREQUEST);
		}
	}
	
	public function executeSelect(){
		$server = $this->initServer();
		$this->content = $server->select(@$_REQUEST['query']);
	}

	private function initServer(){
		$id = @$_REQUEST['server'];
		if(!@$_SESSION['server_'.$id]){
			throw new Exception('server ID:'.$id.' not found');
		}
		return new Server($_SESSION['server_'.$id]);
	}
	
}