<?php
// Config
$pass = 'baka';
$jsonFile = 'data.json';


header('Content-Type: text/plain');
$changed = false;

if ($_GET['pass'] === $pass) {
	$data = json_decode(file_get_contents($jsonFile),1);

	if (isset($_GET['isPaused'])) {
		if ($data['pause'] == 1) {
			echo 1;
		} else {
			echo 0;
		}
	}
	if (isset($_GET['getTime'])) {
		echo $data['time'];
	}

	if (isset($_GET['setTime'])) {
		$data['time'] = $_GET['setTime'];
		$changed=true;
	}
	if (isset($_GET['pause'])) {
		$data['pause'] = true;
		$changed = true;
	}
	if (isset($_GET['play'])) {
		$data['pause'] = false;
		$changed = true;
	}
	if (isset($_GET['reset'])) {
		$data['pause'] = true;
		$data['time'] = 0;
		$changed = true;
	}

	if ($changed===true) {
		file_put_contents($jsonFile, json_encode($data));
	}
} else {
	echo "Invalid password :>";
}