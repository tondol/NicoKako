<?php

define('LIBRARY_DIR', SYSTEM_DIR . "library/");
ini_set('include_path', ini_get('include_path') . ':' . LIBRARY_DIR);

class Controller {
	protected $parent;
	protected $get;
	protected $post;
	protected $config;
	protected $chain;
	protected $variables;
	
	function __construct(Application $app) {
		$this->app = $app;
		$this->get = &$this->app->get;
		$this->post = &$this->app->post;
		$this->config = &$this->app->config;
		$this->chain = $this->app->chain;
	}
	
	function run() {
		$this->render();
	}
	function render() {
		require_once $this->app->get_template_path();
	}
	
	// set variable by module
	function set($key, $value) {
		$this->variables[$key] = $value;
	}
	function set_by_ref($key, &$value) {
		$this->variables[$key] = &$value;
	}
	// get variable by template
	function get($key) {
		return $this->variables[$key];
	}
	
	// get chain of the controller
	function get_chain() {
		return $this->chain;
	}
	// get name for specified chain (default: this)
	function get_name($chain=null) {
		if (is_null($chain)) {
			$chain = $this->chain;
		}
		return $this->config["chain"][$chain];
	}
	// get title for specified chain (default: this)
	function get_title($chain=null) {
		if (is_null($chain)) {
			$chain = $this->chain;
		}
		if ($chain == $this->config["application_main"]) {
			return $this->config["application_title"];
		} else {
			return $this->config["chain"][$chain];
		}
	}
	// get urk for specified chain (default: this)
	function get_url($chain=null) {
		if (is_null($chain)) {
			$chain = $this->chain;
		}
		if ($chain == $this->config["application_main"]) {
			return $this->config["application_url"];
		} else {
			return $this->config["application_url"] . $chain . DIRECTORY_SEPARATOR;
		}
	}
	// get url for specified path
	function get_public($path=null) {
		if (is_null($path)) {
			return $this->config["application_url"];
		} else {
			return $this->config["application_url"] . $path;
		}
	}
	// include template for specified path
	function include_template($path) {
		include_once $this->config["template_dir"] . $path;
	}
}
