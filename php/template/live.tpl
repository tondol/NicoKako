<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<?php
	$live = $this->get("live");
?>

<div class="page-header">
	<h1><?= h($this->get_title()) ?></h1>
</div>
<div class="page-header">
	<h2>videos <small>動画一覧</small></h2>
</div>

<?php if (count($this->get("videos"))): ?>
<div class="row">
	<?php foreach ($this->get("videos") as $i => $video): ?>
		<?php
			$video_url = $this->get_url("live/video") . "?id=" . $video["id"];
			$thumb_url = $this->get_public("contents/" . $live["nicoLiveId"] . ".jpg");
			$filesize = sprintf("%.2f", $video["filesize"] / 1000000.0);
		?>
	<div class="col-sm-4 col-md-3">
		<div class="thumbnail">
			<a href="<?= h($video_url) ?>">
				<img src="<?= h($thumb_url) ?>" />
			</a>
			<div class="caption">
				<p><?= h($live["title"]) ?></p>
				<p><a href="<?= h($video_url) ?>" class="btn btn-primary">
					再生する（<?= h($filesize) ?>MB）
				</a></p>
			</div><!-- /caption -->
		</div><!-- /thumbnail -->
	</div><!-- /col -->
	<?php endforeach ?>
</div><!-- /row -->
<?php else: ?>
<p>動画がありません。</p>
<?php endif ?>

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
	<a href="http://live.nicovideo.jp/gate/<?= h($live["nicoLiveId"]) ?>" class="btn btn-default">
		公式視聴
	</a>
</p>

<?php $this->include_template('include/footer.tpl') ?>
