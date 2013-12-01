<?php

require_once 'lives.php';

class Controller_live extends Controller {
	function get_title($chain=null) {	
		return $this->live["title"];
	}
	function get_url($chain=null) {
		if ((is_null($chain) || $chain == $this->chain) && isset($this->get["id"])) {
			return parent::get_url() . "?id=" . $this->live["id"];
		} else {
			return parent::get_url($chain);
		}
	}

	function run() {
		$lives = new Model_lives();

		if (isset($this->get["id"])) {
			$this->live = $lives->select($this->get["id"]);
			$this->set("live", $this->live);
		}

		$this->render();
	}
}
