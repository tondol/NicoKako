<?php

require_once 'lives.php';
require_once 'videos.php';

class Controller_live_video extends Controller {
	function get_title($chain=null) {	
		return $this->live["title"];
	}
	function get_url($chain=null) {
		if ((is_null($chain) || $chain == $this->chain) && isset($this->video["id"])) {
			return parent::get_url() . "?id=" . $this->video["id"];
		} else if ($chain == "live" && isset($this->live["id"])) {
			return parent::get_url($chain) . "?id=" . $this->live["id"];
		} else {
			return parent::get_url($chain);
		}
	}

	function run() {
		$lives = new Model_lives();
		$videos = new Model_videos();

		if (isset($this->get["id"])) {
			$this->video = $videos->select($this->get["id"]);
			$this->live = $lives->select($this->video["liveId"]);
			$this->set("video", $this->video);
			$this->set("live", $this->live);
		}

		$this->render();
	}
}
