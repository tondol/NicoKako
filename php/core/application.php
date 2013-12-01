<?php

require_once "controller.php";
require_once "utilities.php";

class Application {
	public $get;
	public $post;
	public $config;
	public $chain;
	
	function __construct() {
		$this->get = &$_GET;
		$this->post = &$_POST;
		$this->config = &$GLOBALS["config"];
		$this->load();
	}
	
	function load() {
		// normalize parameter: chain
		$chain = explode(DIRECTORY_SEPARATOR, $this->get["chain"]);
		foreach ($chain as $key => $value) {
			// avoid directory traversal
			$chain[$key] = basename($value);
			// avoid null
			if ($chain[$key] == "") {
				unset($chain[$key]);
			}
		}
		$imploded = implode(DIRECTORY_SEPARATOR, $chain);
		
		// check the existence
		foreach ($this->config["chain"] as $key => $value) {
			if ($imploded == $key) {
				$this->chain = $imploded;
				break;
			}
		}
		
		// main or missing
		if (!isset($this->chain)) {
			if ($imploded == "") {
				$this->chain = $this->config["application_main"];
			} else {
				header("HTTP/1.0 404 Not Found");
				$this->chain = $this->config["application_missing"];
			}
		}
	}
	
	function run() {
		// get controller name and path for specified chain
		$controller_name = "Controller_" . str_replace(DIRECTORY_SEPARATOR, "_", $this->chain);
		$controller_path = $this->config["controller_dir"] . $this->chain . ".php";
		
		// check the existence
		if (file_exists($controller_path)) {
			require_once $controller_path;
		} else {
			$controller_name = "Controller";
		}
		
		// load controller
		$controller = new $controller_name($this);
		$controller->run();
	}
	function get_template_path() {
		// get template path for specified chain
		$template_dir = $this->config["template_dir"];
		$template_path = $template_dir . $this->chain . ".tpl";
		
		// check the existence
		if (!file_exists($template_path)) {
			$template_path = $template_dir . $this->config["application_main"] . ".tpl";
		}
		return $template_path;
	}
}
