<?php

require_once 'lives.php';
require_once 'logs.php';

class Controller_downloader_register extends Controller {
	private $db = null;
	private $is_valid = true;
	private $is_success = true;
	private $validation_error = array();
	private $submission_error = array();

	function get_live_id() {
		$pattern = "!http://live\.nicovideo\.jp/gate/([0-9A-Za-z]+)!";
		if (preg_match($pattern, $this->post["url"], $matches)) {
			$this->live_id = $matches[1];
		}

		$pattern = "!http://live\.nicovideo\.jp/watch/([0-9A-Za-z]+)!";
		if (preg_match($pattern, $this->post["url"], $matches)) {
			$this->live_id = $matches[1];
		}
	}
	function get_live_title() {
		$url = "http://live.nicovideo.jp/gate/" . $this->live_id;

		if ($response = @file_get_contents($url)) {
			$document = new DOMDocument();
			@$document->loadHTML($response);
			$metas = $document->getElementsByTagName("meta");

			foreach ($metas as $meta) {
				$property = $meta->getAttribute("property");
				$content = $meta->getAttribute("content");
				if ($property == "og:title") {
					$this->live_title = $content;
                                }
			}
		}
	}
	function get_live() {
		$lives = new Model_lives();
		$this->live = $lives->select_by_nico_live_id($this->live_id);
	}

	function validate() {
		$this->get_live_id();
		$this->get_live_title();
		$this->get_live();

		if (isset($this->post["timeshift"]) && !empty($this->post["timeshift"])) {
			ob_start();
			passthru("ruby " . SYSTEM_DIR . "ruby/watching_reservation.rb register {$this->live_id} 2>&1");
			$data = json_decode(ob_get_contents(), true);
			ob_end_clean();
			ob_start();
			passthru("ruby " . SYSTEM_DIR . "ruby/watching_reservation.rb watch {$this->live_id} 2>&1");
			$data = json_decode(ob_get_contents(), true);
			ob_end_clean();
		}
		if (isset($this->post["confirm"])) {
			ob_start();
			passthru("ruby " . SYSTEM_DIR . "ruby/get_player_status.rb {$this->live_id} 2>&1");
			$this->params = json_decode(ob_get_contents(), true);
			ob_end_clean();
		}

		if (is_null($this->live_id)) {
			$this->is_valid = false;
			$this->validation_error[] =
				"URLの形式が正しくありません。";
		} else if (is_null($this->live_title)) {
			$this->is_valid = false;
			$this->validation_error[] =
				"タイトルの取得に失敗しました。";
		} else if ($this->live) {
			$this->is_valid = false;
			$this->validation_error[] =
				"この放送はすでに登録されています。";
		} else if (isset($this->post["confirm"]) && empty($this->params["contents"])) {
			$this->is_valid = false;
			$this->validation_error[] =
				"タイムシフト再生情報を取得できません。";
		}

		return $this->is_valid;
	}
	function submit() {
		$lives = new Model_lives();
		$logs = new Model_logs();
		$result = $lives->insert_into(
			$this->live_id,
			$this->live_title);
		$logs->d("front", "downloader/register: " . $this->live_title);

		if ($result) {
			$this->is_success = true;
		} else {
			$this->is_success = false;
			$this->submission_error[] =
				"放送の登録に失敗しました。";
		}

		return $this->is_success;
	}
	function run() {
		if (isset($this->post["confirm"])) {
			$this->validate();
			$this->set("live_id", $this->live_id);
			$this->set("live_title", $this->live_title);
			$this->set("params", $this->params);

		} else if (isset($this->post["submit"])) {
			$this->validate();
			$this->set("live_id", $this->live_id);
			$this->set("live_title", $this->live_title);
			$this->set("params", $this->params);

			if ($this->is_valid) {
				$this->submit();
			}
		}

		$this->set("is_valid", $this->is_valid);
		$this->set("validation_error", $this->validation_error);
		$this->set("is_success", $this->is_success);
		$this->set("submission_error", $this->submission_error);
		$this->render();
	}
}
