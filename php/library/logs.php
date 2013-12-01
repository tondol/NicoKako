<?php

class Model_logs {
	function __construct() {
		$this->config = &$GLOBALS["config"];
		$this->db = DB::get_instance();
	}

	function select_all() {
		$sql = "SELECT *" .
			" FROM `logs`" .
			" ORDER BY `createdAt` DESC, `id` DESC" .
			" LIMIT 0, 100";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchAll(PDO::FETCH_ASSOC);
	}
}
