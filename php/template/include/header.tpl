<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<link rel="stylesheet" type="text/css" href="<?= h($this->get_public("assets/css/bootstrap.min.css")) ?>" />
	<link rel="stylesheet" type="text/css" href="<?= h($this->get_public("assets/css/user.css")) ?>" />
	<script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="<?= h($this->get_public("assets/js/bootstrap.min.js")) ?>"></script>
<?php if ($this->chain == "live/video"): ?>
	<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/dplayer/1.16.0/DPlayer.min.css" />
	<script src="//cdnjs.cloudflare.com/ajax/libs/flv.js/1.3.3/flv.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/dplayer/1.16.0/DPlayer.min.js"></script>
<?php endif ?>
	<title><?= $this->get_title() ?></title>
</head>
<body>
<div class="container">

<div id="header">
	<div class="navbar navbar-inverse navbar-static-top">
		<div class="container">
			<div class="navbar-header">
				<a class="navbar-brand" href="<?= h($this->get_url("index")) ?>">NicoKako</a>
			</div><!-- /navbar-header -->
			<div class="navbar-collapse">
				<ul class="nav navbar-nav">
					<li><a href="<?= h($this->get_url("index")) ?>">index</a></li>
					<li><a href="<?= h($this->get_url("downloader")) ?>">downloader</a></li>
					<li><a href="<?= h($this->get_url("timeshift")) ?>">timeshift</a></li>
					<li><a href="<?= h($this->get_url("logs")) ?>">logs</a></li>
					<li><a href="<?= h($this->get_url("help")) ?>">help</a></li>
				</ul>
			</div><!-- /navbar-collapse -->
		</div><!-- /container -->
	</div><!-- /navbar -->
</div><!-- /header -->

<div class="container">
