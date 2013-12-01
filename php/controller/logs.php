<?php

require_once 'lives.php';
require_once 'logs.php';

class Controller_logs extends Controller {
	function run() {
		$lives = new Model_lives();
		$logs = new Model_logs();
		$this->set("logs", $logs->select_all());
		$this->set("count_lives", $lives->count());
		$this->set("count_not_downloaded_lives", $lives->count_not_downloaded());
		$this->set("sum_filesize", $lives->sum_filesize());
		$this->render();
	}
}
