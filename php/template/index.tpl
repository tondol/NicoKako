<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<div class="page-header">
	<h1>NicoKako</h1>
</div>

<p>初めての方は<a href="<?= h($this->get_url("help")) ?>">help</a>をどうぞ。</p>

<div class="page-header">
	<h2>lives <small>番組一覧</small></h2>
</div>

<?php if (count($this->get("lives"))): ?>
<div class="row">
	<?php foreach ($this->get("lives") as $live): ?>
		<?php
			$thumbnail_url = $this->get_public("contents/" . $live["nicoLiveId"] . ".jpg");
			$unavailable_url = $this->get_public("assets/images/unavailable.png");
			$live_url = $this->get_url("live") . "?id=" . $live["id"];
		?>
	<div class="col-sm-4 col-md-3">
		<div class="thumbnail">
		<?php if (isset($live["downloadedAt"])): ?>
			<a href="<?= h($live_url) ?>">
				<img src="<?= h($thumbnail_url) ?>" height="144" />
			</a>
		<?php else: ?>
				<img src="<?= h($unavailable_url) ?>" height="144" />
		<?php endif ?>
			<div class="caption">
				<p><?= h($live["title"]) ?></p>
		<?php if (isset($live["downloadedAt"])): ?>
				<p><a href="<?= h($live_url) ?>" class="btn btn-primary">
					再生する
				</a></p>
		<?php else: ?>
				<p><a class="btn btn-primary disabled">未ダウンロード</a></p>
		<?php endif ?>
			</div><!-- /caption -->
		</div><!-- /thumbnail -->
	</div><!-- /col -->
	<?php endforeach ?>
</div><!-- /row -->
<?php else: ?>
<p>番組がありません。</p>
<?php endif ?>

<?php $this->include_template('include/footer.tpl') ?>
