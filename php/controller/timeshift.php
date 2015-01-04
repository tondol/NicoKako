<?php

class Controller_timeshift extends Controller {
	function run() {
		ob_start();
		passthru("ruby " . SYSTEM_DIR . "ruby/watching_reservation.rb 2>&1");
		$items = array_reverse(json_decode(ob_get_contents(), true));
		ob_end_clean();
		$this->set("items", $items);
		$this->render();
	}
}
