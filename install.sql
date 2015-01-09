--
-- テーブルの構造 `lives`
--

CREATE TABLE IF NOT EXISTS `lives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nicoLiveId` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `retryCount` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `downloadedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nicoLiveId` (`nicoLiveId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

--
-- テーブルの構造 `logs`
--

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kind` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

--
-- テーブルの構造 `videos`
--

CREATE TABLE IF NOT EXISTS `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `liveId` int(11) NOT NULL,
  `vpos` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filesize` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `modifiedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `liveId` (`liveId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;
