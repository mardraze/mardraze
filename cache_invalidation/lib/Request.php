<?php

/**
 * @author Marcin
 * @version 1.0
 * @updated 24-maj-2013 13:31:25
 */
class Request
{

	public $uri;
	public $method;
	public $contentType;
	public $headers;
	
	function Request($uri, $headerNames = array())
	{
		$this->uri = $uri;
		$this->method = $this->getMethod();
		$this->contentType = $this->getContentType();
		
		$headers = array();
		
		foreach ($headerNames as $k => $headerName){
			
			$headers[$headerName] = $this->getHeader($headerName);
			
		}
		
		$this->headers = $headers;
	}


	
	private function getHeader($name)
	{
		$name = strtoupper(preg_replace('/([A-Z])/', '_$1', $name));
		if (isset($_SERVER['HTTP_'.$name])) {
			return $_SERVER['HTTP_'.$name];
		} elseif (isset($_SERVER[$name])) {
			return $_SERVER[$name];
		} else {
			return NULL;
		}
	}
	
	private function getMethod()
	{
		// get HTTP method from HTTP header
		$method = strtoupper($this->getHeader('requestMethod'));
		if (!$method) {
			$method = 'GET';
		}
		
		return $method;
	}
	
	private function getContentType()
	{
		$contentType = $this->getHeader('contentType');
		$parts = explode(';', $contentType);
	
		return @$parts[0].'';
	}
	
	
	}
	