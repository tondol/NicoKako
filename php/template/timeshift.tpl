<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<div class="page-header">
	<h1><?= h($this->get_title()) ?> <small>タイムシフト予約</small></h1>
</div>
<div class="page-header">
	<h2>reservations <small>予約一覧</small></h2>
</div>

<?php if (count($this->get("items"))): ?>
<ul>
	<?php foreach ($this->get("items") as $i => $item): ?>
	<li>
		<?php
			$watch_url = $this->get_url("timeshift/watch") . "?id=" . $item["vid"];
			$delete_url = $this->get_url("timeshift/delete") . "?id=" . $item["vid"];
		?>
		<a href="http://live.nicovideo.jp/gate/lv<?= h($item["vid"]) ?>"><?= h($item["title"]) ?></a>
		<a href="<?= h($watch_url) ?>" class="btn btn-default">アクティベート</a>
		<a href="<?= h($delete_url) ?>" class="btn btn-danger">削除</a>
	</li>
	<?php endforeach ?>
</ul>
<?php else: ?>
<p>予約がありません。</p>
<?php endif ?>

<div class="page-header">
	<h2>maintenance <small>管理</small></h2>
</div>

<p>
<?php
	$register_url = $this->get_url("timeshift/register");
?>
	<a href="<?= h($register_url) ?>" class="btn btn-primary">
		タイムシフト予約する
	</a>
</p>

<?php $this->include_template('include/footer.tpl') ?>
