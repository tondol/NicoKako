<?php

require_once 'db.php';

class Model_videos {
	function __construct() {
		$this->config = &$GLOBALS["config"];
		$this->db = DB::get_instance();
	}

	function select($id) {
		$sql = "SELECT *" .
			" FROM `videos`" .
			" WHERE `id` = ?";
		$statement = $this->db->prepare($sql);
		$statement->execute(array($id));
		return $statement->fetch(PDO::FETCH_ASSOC);
	}
	function select_all_by_live_id($live_id) {
		$sql = "SELECT *" .
			" FROM `videos`" .
			" WHERE `liveId` = ?";
		$statement = $this->db->prepare($sql);
		$statement->execute(array($live_id));
		return $statement->fetchAll(PDO::FETCH_ASSOC);
	}
	function count() {
		$sql = "SELECT COUNT(*) AS `count`" .
			" FROM `videos`";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchColumn();
	}
	function sum_filesize() {
		$sql = "SELECT SUM(`filesize`) AS `sum`" .
			" FROM `videos`";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchColumn();
	}
}
