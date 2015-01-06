<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<div class="page-header">
	<h1><?= h($this->get_title()) ?> <small>タイムシフト予約</small></h1>
</div>
<div class="page-header">
	<h2>reservations <small>予約一覧</small></h2>
</div>

<?php if (count($this->get("items"))): ?>
	<?php foreach ($this->get("items") as $i => $item): ?>
<div class="panel panel-default">
		<?php
			switch ($item["status"]) {
				case "WATCH": $status = "視聴可能（アーカイブ可能）"; break;
				case "FIRST_WATCH": $status = "未視聴"; break;
				case "LIMIT_DATE_OUT":
				case "USE_LIMIT_DATE_OUT": $status = "視聴期間終了"; break;
				case "PRODUCT_ARCHIVE_TIMEOUT": $status = "アーカイブ公開期間終了"; break;
				case "RESERVED": $status = "予約中"; break;
				default: $status = $item["status"]; break;
			}
			$live_url = "http://live.nicovideo.jp/gate/lv" . $item["vid"];
			$watch_url = $this->get_url("timeshift/watch") . "?id=" . $item["vid"];
			$delete_url = $this->get_url("timeshift/delete") . "?id=" . $item["vid"];
		?>
	<div class="panel-heading">
		<a href="<?= h($live_url) ?>"><?= h($item["title"]) ?></a>
	</div>
	<div class="panel-body">
		<span class="pull-left">
			<?= h($status) ?>
		<?php if ($item["status"] == "FIRST_WATCH"): ?>
			/ 視聴期限 <?= h(date("Y-m-d H:i:s", $item["expire"])) ?>
		<?php endif ?>
		</span>
		<span class="pull-right">
		<?php if ($item["status"] == "WATCH"): ?>
			<form action="<?= h($this->get_url("downloader/register")) ?>" method="post" style="display: inline">
				<input type="hidden" name="url" value="<?= h($live_url) ?>" />
				<button type="submit" class="btn btn-primary">アーカイブ</button>
			</form>
		<?php elseif ($item["status"] == "FIRST_WATCH"): ?>
			<a href="<?= h($watch_url) ?>" class="btn btn-primary">アクティベート</a>
		<?php endif ?>
			<a href="<?= h($delete_url) ?>" class="btn btn-danger">削除</a>
		</span>
	</div>
</div>
	<?php endforeach ?>
<?php else: ?>
<p>予約がありません。</p>
<?php endif ?>

<div class="page-header">
	<h2>maintenance <small>管理</small></h2>
</div>

<p>
	<a href="<?= h($this->get_url("timeshift/register")) ?>" class="btn btn-primary">
		タイムシフト予約する
	</a>
</p>

<?php $this->include_template('include/footer.tpl') ?>
