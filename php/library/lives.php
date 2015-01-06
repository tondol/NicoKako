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
			" ORDER BY `downloadedAt` IS NULL ASC," .
                        " `deletedAt` IS NULL DESC," .
                        " `createdAt` DESC";
		$statement = $this->db->prepare($sql);
		$statement->execute();
		return $statement->fetchAll(PDO::FETCH_ASSOC);
	}
	function select_all_not_downloaded() {
		// ダウンロード対象の動画を取得する
		$sql = "SELECT * FROM `lives`" .
			" WHERE `downloadedAt` IS NULL AND `deletedAt` IS NULL" .
			" ORDER BY `createdAt` ASC";
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
	function delete($id) {
		$sql = "DELETE FROM `lives`" .
			" WHERE `id` = ?";
		$statement = $this->db->prepare($sql);
		return $statement->execute(array($id));
	}
}
