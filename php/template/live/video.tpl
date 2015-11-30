<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<?php
	$live = $this->get("live");
	$video = $this->get("video");
	$video_url = $this->config["contents_dir_url"] . "/" . $video["filename"];
	$thumb_url = $this->config["contents_dir_url"] . "/" . $live["nicoLiveId"] . ".jpg";
	$comments_url = $this->config["contents_dir_url"] . "/" . $live["nicoLiveId"] . ".xml";
	$filesize = sprintf("%.2f", $video["filesize"] / 1000000.0);
?>

<div class="page-header">
	<h1><?= h($this->get_title()) ?></h1>
</div>
<div class="page-header">
	<h2>player <small>再生</small></h2>
</div>

<div id="player"></div> 
<script type="text/javascript">
	var player = jwplayer("player");
	player.setup({
		file: "<?= h($video_url) ?>",
		image: "<?= h($thumb_url) ?>",
		width: 640,
		height: 360
	});
</script>

<div class="page-header">
	<h2>summary <small>概要</small></h2>
</div>

<dl>
	<dt>登録日時</dt>
<?php if (isset($video["createdAt"])): ?>
	<dd><?= h($video["createdAt"]) ?></dd>
<?php else: ?>
	<dd>記録なし</dd>
<?php endif ?>
	<dt>ダウンロード日時</dt>
<?php if (isset($video["modifiedAt"])): ?>
	<dd><?= h($video["modifiedAt"]) ?></dd>
<?php else: ?>
	<dd>記録なし</dd>
<?php endif ?>
</dl>

<p>
	<a href="<?= h($video_url) ?>" class="btn btn-primary">
		動画ファイルのダウンロード（<?= h($filesize) ?>MB）
	</a>
	<a href="<?= h($comments_url) ?>" class="btn btn-default">
		コメントのダウンロード
	</a>
</p>

<div class="page-header">
	<h2>maintenance <small>管理</small></h2>
</div>

<p>
<?php
	$delete_url = $this->get_url("live/video/delete") . "?id={$video["id"]}";
?>
	<a href="<?= h($delete_url) ?>" class="btn btn-danger">
		この動画を削除する
	</a>
</p>

<?php $this->include_template('include/footer.tpl') ?>
