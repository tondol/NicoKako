<?php

require_once 'lives.php';
require_once 'videos.php';

class Controller_live extends Controller {
	function get_title($chain=null) {	
		return $this->live["title"];
	}
	function get_url($chain=null) {
		if ((is_null($chain) || $chain == $this->chain) && isset($this->live["id"])) {
			return parent::get_url() . "?id=" . $this->live["id"];
		} else {
			return parent::get_url($chain);
		}
	}

	function run() {
		$lives = new Model_lives();
		$videos = new Model_videos();

		if (isset($this->get["id"])) {
			$this->live = $lives->select($this->get["id"]);
			$videos = $videos->select_all_by_live_id($this->live["id"]);
			$this->set("live", $this->live);
			$this->set("videos", $videos);
		}

		$this->render();
	}
}
