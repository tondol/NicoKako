<?php

class DB {
	private static $instance = null;

	function __construct() {
		$this->config = &$GLOBALS["config"];
		$this->db = $this->get_db();
	}
	function get_db() {
		try {
			return new PDO(
				"mysql:host={$this->config["db"]["host"]}" .
					";port={$this->config["db"]["port"]}" .
					";dbname={$this->config["db"]["database"]}",
				$this->config["db"]["user"],
				$this->config["db"]["password"],
				array(
					PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8",
				));
		} catch (PDOException $e) {
			exit("db connection error: " . $e->getMessage());
		}
	}

	static function get_instance() {
		if (is_null(self::$instance)) {
			self::$instance = new DB();
		}
		return self::$instance->db;
	}
}
