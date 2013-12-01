<?php

require_once 'lives.php';

class Controller_index extends Controller {
	function run() {
		$lives = new Model_lives();
		$this->set("lives", $lives->select_all());
		$this->render();
	}
}
