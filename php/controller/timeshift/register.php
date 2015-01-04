<?php

class Controller_timeshift_register extends Controller {
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
	function validate() {
		$this->get_live_id();

		if (is_null($this->live_id)) {
			$this->is_valid = false;
			$this->validation_error[] =
				"URLの形式が正しくありません。";
		}

		return $this->is_valid;
	}
	function submit() {
		ob_start();
		passthru("ruby " . SYSTEM_DIR . "ruby/watching_reservation.rb register {$this->live_id} 2>&1");
		$status = json_decode(ob_get_contents(), true);
		ob_end_clean();
		$this->is_success = true;

		return $this->is_success;
	}
	function run() {
		if (isset($this->post["confirm"])) {
			$this->validate();
			$this->set("live_id", $this->live_id);

		} else if (isset($this->post["submit"])) {
			$this->validate();
			$this->set("live_id", $this->live_id);

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
