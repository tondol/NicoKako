<?php

require_once 'lives.php';
require_once 'videos.php';
require_once 'logs.php';

class Controller_live_delete extends Controller {
	private $db = null;
	private $is_valid = true;
	private $is_success = true;
	private $validation_error = array();
	private $submission_error = array();

	function get_url($chain=null) {
		if ((is_null($chain) || $chain == $this->chain) && isset($this->live['id'])) {
			return parent::get_url() . "?id=" . $this->live['id'];
		} else if ($chain == "live" && isset($this->live["id"])) {
			return parent::get_url($chain) . "?id=" . $this->live["id"];
		} else {
			return parent::get_url($chain);
		}
	}

	function get_live() {
		$lives = new Model_lives();
		$this->live = $lives->select($this->get['id']);
	}
	function clean_files() {
		$videos = new Model_videos();
		foreach ($videos->select_all_by_live_id($this->live['id']) as $video) {
			$filename = $video["filename"];
			$filepath = $this->config["contents"] . $filename;
			if (file_exists($filepath)) {
				unlink($filepath);
			}
		}

		$filename = $this->live["nicoLiveId"] . ".xml";
		$filepath = $this->config["contents"] . $filename;
		if (file_exists($filepath)) {
			unlink($filepath);
		}

		$filename = $this->live["nicoLiveId"] . ".jpg";
		$filepath = $this->config["contents"] . $filename;
		if (file_exists($filepath)) {
			unlink($filepath);
		}
	}

	function validate() {
		$this->get_live();

		if (empty($this->live)) {
			$this->is_valid = false;
			$this->validation_error[] =
				"無効なタイトルが指定されました。";
		}

		return $this->is_valid;
	}
	function submit() {
		$lives = new Model_lives();
		$videos = new Model_videos();
		$logs = new Model_logs();

		$this->clean_files();
		$videos->delete_by_live_id($this->live["id"]);
		$channels->delete($this->live["id"]);
		$logs->d("front", "live/delete: " . $this->live["title"]);

		$this->is_success = true;
		return $this->is_success;
	}
	function run() {
		if (isset($this->post["confirm"])) {
			$this->validate();
			$this->set("live", $this->live);
		} else if (isset($this->post["submit"])) {
			$this->validate();
			$this->set("live", $this->live);

			if ($this->is_valid) {
				$this->submit();
			}
		} else {
			$this->validate();
			$this->set("live", $this->live);
		}

		$this->set("is_valid", $this->is_valid);
		$this->set("validation_error", $this->validation_error);
		$this->set("is_success", $this->is_success);
		$this->set("submission_error", $this->submission_error);
		$this->render();
	}
}
