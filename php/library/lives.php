<?php

require_once 'db.php';

class Model_lives {
	function __construct() {
		$this->config = &$GLOBALS["config"];
		$this->db = DB::get_instance();
	}

	function select($id) {
		$sql = "SELECT *" .
			" FROM `lives`" .
			" WHERE `id` = ?";
		$statement = $this->db->prepare($sql);
		$statement->execute(array($id));
		return $statement->fetch(PDO::FETCH_ASSOC);
	}
	function select_by_nico_live_id($live_id) {
		$sql = "SELECT *" .
			" FROM `lives`" .
			" WHERE `nicoLiveId` = ?";
		$statement = $this->db->prepare($sql);
		$statement->execute(array($live_id));
		return $statement->fetch(PDO::FETCH_ASSOC);
	}
	function select_all() {
		$sql = "SELECT *" .
			" FROM `lives`" .
			" WHERE `deletedAt` IS NULL" .
			" ORDER BY `downloadedAt` IS NULL DESC, `downloadedAt` DESC";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchAll(PDO::FETCH_ASSOC);
	}
	function insert_into($live_id, $title) {
		$sql = "INSERT INTO `lives`" .
			" (`nicoLiveId`, `title`, `createdAt`)" .
			" VALUES (?, ?, ?)";
		$statement = $this->db->prepare($sql);
		return $statement->execute(array(
			$live_id,
			$title,
			current_date(),
		));
	}
	function count() {
		$sql = "SELECT COUNT(*) AS `count`" .
			" FROM `lives`";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchColumn();
	}
	function count_not_downloaded() {
		$sql = "SELECT COUNT(*) AS `count`" .
			" FROM `lives`" .
			" WHERE `downloadedAt` IS NULL";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchColumn();
	}
	function sum_filesize() {
		$sql = "SELECT SUM(`filesize`) AS `sum`" .
			" FROM `lives`" .
			" WHERE `downloadedAt` IS NOT NULL";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchColumn();
	}
}
