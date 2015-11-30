<?php

require_once 'lives.php';
require_once 'videos.php';

class Controller_live_video extends Controller {
	function get_title($chain=null) {	
		return $this->live["title"];
	}
	function get_url($chain=null, $params=null) {
		if ((is_null($chain) || $chain == $this->chain) && isset($this->video["id"])) {
			$params = array_merge(
				array('id' => $this->video['id']),
				is_null($params) ? array() : $params
			);
		} else if ($chain == "live" && isset($this->live["id"])) {
			$params = array_merge(
				array('id' => $this->live['id']),
				is_null($params) ? array() : $params
			);
		}
		return parent::get_url($chain, $params);
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
