<?php 
function include_grid($id){
	$template = file_get_contents('_include_grid.html');
	echo str_replace('####ID####', $id, $template);
}

?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<title>jqGrid PHP Demo</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" type="text/css" href="jqgrid/jquery-ui.css" />
		<link rel="stylesheet" type="text/css" href="jqgrid/ui.jqgrid.css" />
		<link rel="stylesheet" type="text/css" href="jqgrid/ui.multiselect.css" />
		<script type="text/javascript" src="jqgrid/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="jqgrid/grid.locale-pl.js"></script>
		<script type="text/javascript">
			jQuery.jgrid.no_legacy_api = true;
		</script>
		<script type="text/javascript" src="jqgrid/jquery.jqGrid.src.js"></script>
	</head>
	<body>
	<?php include_grid('11234'); ?>
	<?php include_grid('11235'); ?>
	<?php include_grid('11236'); ?>
	</body>
</html>

