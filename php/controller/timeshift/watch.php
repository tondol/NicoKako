<?php

class Controller_timeshift_watch extends Controller {
	private $is_valid = true;
	private $is_success = true;
	private $validation_error = array();
	private $submission_error = array();

	function get_url($chain=null) {
		if ((is_null($chain) || $chain == $this->chain) && isset($this->live_id)) {
			return parent::get_url() . "?id=" . $this->live_id;
		} else {
			return parent::get_url($chain);
		}
	}

	function get_live_id() {
		$pattern = "/([0-9]+)/";
		if (preg_match($pattern, $this->get["id"], $matches)) {
			$this->live_id = "lv" . $matches[1];
		}
	}
	function validate() {
		$this->get_live_id();

		if (is_null($this->live_id)) {
			$this->is_valid = false;
			$this->validation_error[] =
				"IDの形式が正しくありません。";
		}

		return $this->is_valid;
	}
	function submit() {
		ob_start();
		passthru("ruby " . SYSTEM_DIR . "ruby/watching_reservation.rb watch {$this->live_id} 2>&1");
		$status = json_decode(ob_get_contents(), true);
		ob_end_clean();
		$this->is_success = true;

		return $this->is_success;
	}
	function run() {
		$this->validate();
		$this->set("live_id", $this->live_id);

		if (isset($this->post["submit"])) {
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
