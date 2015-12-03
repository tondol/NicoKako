<?php

require_once 'lives.php';
require_once 'videos.php';
require_once 'controller_kako.php';

class Controller_live extends Controller_kako {
	function get_title($chain=null) {
		return $this->get_title_helper($chain, array(
			$this->chain => $this->live['title'],
		));
	}
	function get_url($chain=null, $params=null) {
		return $this->get_url_helper($chain, $params, array(
			$this->chain => array('id' => $this->live['id']),
		));
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
