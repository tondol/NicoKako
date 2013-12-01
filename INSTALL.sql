CREATE TABLE IF NOT EXISTS `lives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nicoLiveId` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `filesize` int(11) DEFAULT NULL,
  `retryCount` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `downloadedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nicoLiveId` (`nicoLiveId`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kind` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
