<?php

require_once 'lives.php';

class Controller_downloader extends Controller {
	function run() {
		$lives = new Model_lives();
		$this->set("lives", $lives->select_all_not_downloaded());
		$this->render();
	}
}
