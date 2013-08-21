<?php

function catchException(Exception $ex, $isPhpError = false){
	Logger::error($ex->getMessage());
	$response = array(
		'status' => $ex->getCode(),
		'data' => array('message' => $ex->getMessage()),
	);
	if(!$isPhpError){
		$response['data']['file'] = $ex->getFile();
		$response['data']['line'] = $ex->getLine();
	}
	echo json_encode($response);
	exit;
}

function phpError() {
	$error = error_get_last();
	if(@$error['type'] & E_WARNING){
		$ex = new Exception($error['file'].'['.$error['line'].']: '.$error['message'], 500);
		catchException($ex, true);
	}
}

error_reporting(E_ALL);
ini_set( "display_errors", "on" );
register_shutdown_function('phpError');
set_exception_handler("catchException");
