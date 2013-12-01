<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<?php
	$live = $this->get("live");
	$video_url = $this->config["application_url"] . "contents/" . $live["filename"];
	$thumb_url = $this->config["application_url"] . "contents/" . $live["nicoLiveId"] . ".jpg";
	$comments_url = $this->config["application_url"] . "contents/" . $live["nicoLiveId"] . ".xml";
	$filesize = sprintf("%.2f", $live["filesize"] / 1000000.0);
?>

<div class="page-header">
	<h1><?= h($this->get_title()) ?></h1>
</div>
<div class="page-header">
	<h2>player <small>再生</small></h2>
</div>

<div id="player"></div> 
<script type="text/javascript">
	jwplayer("player").setup({
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
<?php if (isset($live["createdAt"])): ?>
	<dd><?= h($live["createdAt"]) ?></dd>
<?php else: ?>
	<dd>記録なし</dd>
<?php endif ?>
	<dt>ダウンロード日時</dt>
<?php if (isset($live["downloadedAt"])): ?>
	<dd><?= h($live["downloadedAt"]) ?></dd>
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
	<a href="http://live.nicovideo.jp/gate/<?= h($live["nicoLiveId"]) ?>" class="btn btn-default">
		公式視聴
	</a>
</p>

<?php $this->include_template('include/footer.tpl') ?>
