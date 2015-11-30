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

		if (filesize("{$this->config["contents_dir"]}/{$this->video["filename"]}") == 0) {
			$pathinfo = pathinfo($this->video["filename"]);
			$json = json_decode(shell_exec(
				"ACD_CLI_CACHE_PATH={$this->config["acd_cli_cache_path"]} " .
				"/usr/local/bin/acdcli metadata " .
				"{$this->config["acd_cli_contents_dir"]}/{$this->video["filename"]} 2>&1"
			), true);
			$this->set("video_url", $json["tempLink"] . "?/v." . $pathinfo["extension"]);
		} else {
			$video_url = "{$this->config["contents_dir_url"]}/{$this->video["filename"]}";
			$this->set("video_url", $video_url);
		}

		$this->render();
	}
}
