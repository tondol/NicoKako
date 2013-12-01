<?php

ini_set('error_reporting', E_ALL ^ E_NOTICE);
define('SYSTEM_DIR', dirname(dirname(__FILE__)) . "/");
require_once SYSTEM_DIR . '../html/config.php';

define('SQL_SELECT_CHANNELS', "SELECT *" .
	" FROM `channels`" .
	" WHERE `title` IS NULL OR `description` IS NULL OR `keywords` IS NULL");
define('SQL_UPDATE_CHANNELS', "UPDATE `channels`" .
	" SET `title` = ?, `description` = ?, `keywords` = ?" .
	" WHERE `id` = ?");

define('SQL_SELECT_VIDEOS', "SELECT *" .
	" FROM `videos`" .
	" WHERE `title` IS NULL OR `description` IS NULL");
define('SQL_UPDATE_VIDEOS', "UPDATE `videos`" .
	" SET `title` = ?, `description` = ?" .
	" WHERE `id` = ?");

class Meta {
	private $db = null;

	function __construct() {
		$this->config = &$GLOBALS['config'];
	}

	function get_db() {
		// DB接続を共有
		if (is_null($this->db)) {
			try {
				$this->db = new PDO(
					"mysql:dbname=nicoanime;host=127.0.0.1",
					$this->config["db"]["user"],
					$this->config["db"]["password"],
					array(
						PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8",
					));
			} catch (PDOException $e) {
				exit("db connection error: " . $e->getMessage());
			}
		}

		return $this->db;
	}

	function get_channel_id() {
		return $this->channel_id;
	}
	function get_channel_rss() {
		$uri = "http://ch.nicovideo.jp/" .
			$this->get_channel_id() .
			"/video?rss=2.0";
		$ns = "http://purl.org/dc/elements/1.1/";

		if (is_null($this->channel_title)) {
			if ($response = @file_get_contents($uri)) {
				$document = new SimpleXMLElement($response);
				$this->channel_title =
					(string)$document->channel->children($ns)->creator;
			}
		}
	}
	function get_channel_html() {
		$uri = "http://ch.nicovideo.jp/" .
			$this->get_channel_id();

		if (is_null($this->channel_description) ||
				is_null($this->channel_keywords)) {
			if ($response = @file_get_contents($uri)) {
				$document = new DOMDocument();
				@$document->loadHTML($response);
				$metas = $document->getelementsByTagName("meta");

				foreach ($metas as $meta) {
					$name = $meta->getAttribute("name");
					$content = $meta->getAttribute("content");
					if ($name == "description") {
						$this->channel_description = $content;
					} else if ($name == "keywords") {
						$this->channel_keywords = $content;
					}
				}
			}
		}
	}

	function get_video_id() {
		return $this->video_id;
	}
	function get_video_thumb() {
		$uri = "http://ext.nicovideo.jp/api/getthumbinfo/" .
			$this->get_video_id();

		if (is_null($this->video_title) ||
				is_null($this->video_description)) {
			if ($response = @file_get_contents($uri)) {
				$document = new SimpleXMLElement($response);
				$this->video_title =
					(string)$document->thumb->title;
				$this->video_description =
					(string)$document->thumb->description;
			}
		}
	}

	function main_channels() {
		$db = $this->get_db();
		$statement = $db->prepare(SQL_SELECT_CHANNELS);
		$statement->execute();
		$channels = $statement->fetchAll(PDO::FETCH_ASSOC);

		foreach ($channels as $channel) {
			$this->channel_id = $channel["nicoChannelId"];
			$this->channel_title = null;
			$this->channel_description = null;
			$this->channel_keywords = null;
			$this->get_channel_rss();
			$this->get_channel_html();

			var_dump(array(
				"title" => $this->channel_title,
				"description" => $this->channel_description,
				"keywords" => $this->channel_keywords,
			));
			if (is_null($this->channel_title) ||
					is_null($this->channel_description) ||
					is_null($this->channel_keywords)) {
				continue;
			}

			$statement = $db->prepare(SQL_UPDATE_CHANNELS);
			$statement->execute(array(
				$this->channel_title,
				$this->channel_description,
				$this->channel_keywords,
				$channel["id"],
			));
			$statement->execute();
		}
	}
	function main_videos() {
		$db = $this->get_db();
		$statement = $db->prepare(SQL_SELECT_VIDEOS);
		$statement->execute();
		$videos = $statement->fetchAll(PDO::FETCH_ASSOC);

		foreach ($videos as $video){
			$this->video_id = $video["nicoVideoId"];
			$this->video_title = null;
			$this->video_description = null;
			$this->get_video_thumb();

			var_dump(array(
				"title" => $this->video_title,
				"description" => $this->video_description,
			));
			if (is_null($this->video_title) ||
					is_null($this->video_description)) {
				continue;
			}

			$statement = $db->prepare(SQL_UPDATE_VIDEOS);
			$statement->execute(array(
				$this->video_title,
				$this->video_description,
				$video["id"],
			));
			$statement->execute();
		}
	}
}

$meta = new Meta();
$meta->main_channels();
$meta->main_videos();
