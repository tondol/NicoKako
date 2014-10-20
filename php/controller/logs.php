<?php

require_once 'lives.php';
require_once 'videos.php';
require_once 'logs.php';

class Controller_logs extends Controller {
	function run() {
		$lives = new Model_lives();
		$videos = new Model_videos();
		$logs = new Model_logs();
		$this->set("logs", $logs->select_all());
		$this->set("count_lives", $lives->count());
		$this->set("count_videos", $videos->count());
		$this->set("sum_filesize", $videos->sum_filesize());
		$this->render();
	}
}
