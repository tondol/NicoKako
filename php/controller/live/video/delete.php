<?php

require_once 'lives.php';
require_once 'videos.php';
require_once 'logs.php';

class Controller_live_video_delete extends Controller {
	private $db = null;
	private $is_valid = true;
	private $is_success = true;
	private $validation_error = array();
	private $submission_error = array();

	function get_url($chain=null, $params=null) {
		if ((is_null($chain) || $chain == $this->chain) && isset($this->video['id'])) {
			$params = array_merge(
				array('id' => $this->video['id']),
				is_null($params) ? array() : $params
			);
		} else if ($chain == "live" && isset($this->live["id"])) {
			$params = array_merge(
				array('id' => $this->live['id']),
				is_null($params) ? array() : $params
			);
		} else if ($chain == "live/video" && isset($this->video["id"])) {
			$params = array_merge(
				array('id' => $this->video['id']),
				is_null($params) ? array() : $params
			);
		}
		return parent::get_url($chain, $params);
	}

	function get_video() {
		$videos = new Model_videos();
		$this->video = $videos->select($this->get['id']);
	}
	function get_live() {
		$lives = new Model_lives();
		$this->live = $lives->select($this->video['liveId']);
	}
	function clean_files() {
		$filename = $this->video["filename"];
		$filepath = $this->config["contents_dir"] . "/" . $filename;
		if (empty($filename)) {
			return;
		}
		if (file_exists($filepath)) {
			unlink($filepath);
		}
	}

	function validate() {
		$this->get_video();
		$this->get_live();

		if (empty($this->video)) {
			$this->is_valid = false;
			$this->validation_error[] =
				"無効な動画が指定されました。";
		}

		return $this->is_valid;
	}
	function submit() {
		$videos = new Model_videos();
		$logs = new Model_logs();

		$this->clean_files();
		$videos->delete($this->video["id"]);
		$logs->d("front", "live/video/delete: " . $this->video["filename"]);

		$this->is_success = true;
		return $this->is_success;
	}
	function run() {
		if (isset($this->post["submit"])) {
			$this->validate();
			$this->set("video", $this->video);
			$this->set("live", $this->live);

			if ($this->is_valid) {
				$this->submit();
			}
		} else {
			$this->validate();
			$this->set("video", $this->video);
			$this->set("live", $this->live);
		}

		$this->set("is_valid", $this->is_valid);
		$this->set("validation_error", $this->validation_error);
		$this->set("is_success", $this->is_success);
		$this->set("submission_error", $this->submission_error);
		$this->render();
	}
}
