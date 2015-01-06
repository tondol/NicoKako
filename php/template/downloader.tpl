<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<div class="page-header">
	<h1><?= h($this->get_title()) ?> <small>ダウンロード</small></h1>
</div>
<div class="page-header">
	<h2>lives <small>ダウンロード待ち</small></h2>
</div>

<?php if (count($this->get("lives"))): ?>
	<?php foreach ($this->get("lives") as $i => $live): ?>
<div class="panel panel-default">
		<?php
			$live_url = "http://live.nicovideo.jp/gate/" . $live["nicoLiveId"];
		?>
	<div class="panel-heading">
		<a href="<?= h($live_url) ?>"><?= h($live["title"]) ?></a>
	</div>
	<div class="panel-body">
		登録日時 <?= h($live["createdAt"]) ?> /
		リトライ <?= h($live["retryCount"]) ?>
	</div>
</div>
	<?php endforeach ?>
<?php else: ?>
<p>ダウンロードが完了しました。</p>
<?php endif ?>

<div class="page-header">
	<h2>maintenance <small>管理</small></h2>
</div>

<p>
	<a href="<?= h($this->get_url("downloader/register")) ?>" class="btn btn-primary">
		ダウンロード対象を登録する
	</a>
</p>

<?php $this->include_template('include/footer.tpl') ?>
