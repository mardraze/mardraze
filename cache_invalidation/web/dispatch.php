<?php
require_once dirname(__FILE__).'/../globals/config.php';
require_once dirname(__FILE__).'/../globals/Logger.php';
require_once dirname(__FILE__).'/../globals/handle_error.php';
require_once dirname(__FILE__).'/../src/RestRouting.php';

session_start();

header('Content-Type:application/json; charset=utf8');

$restRouting = new RestRouting();

echo json_encode($restRouting->execute());
