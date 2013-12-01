<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<div class="page-header">
	<h1>logs <small>ログ表示</small></h1>
</div>
<div class="page-header">
	<h2>summary <small>概要</small></h1>
</div>

<dl>
	<dt>番組数</dt>
	<dd><?= h($this->get("count_lives")) ?>個</dd>
	<dt>処理待機中の番組数</dt>
	<dd><?= h($this->get("count_not_downloaded_lives")) ?>個</dd>
	<dt>合計ファイルサイズ（目安）</dt>
	<dd><?= sprintf("%.2f", $this->get("sum_filesize") / 1000000.0) ?> MB</dd>
</dl>

<div class="page-header">
	<h2>latest <small>最新100件のログ</small></h1>
</div>

<table class="table table-striped">
	<thead>
		<tr>
			<th>kind</th>
			<th>name</th>
			<th>message</th>
			<th>created_at</th>
		</tr>
	</thead>
	<tbody>
<?php foreach ($this->get("logs") as $log): ?>
		<tr>
	<?php if ($log["kind"] == "d"): ?>
			<td><span class="label label-info"><?= h($log["kind"]) ?></span></td>
	<?php elseif ($log["kind"] == "e"): ?>
			<td><span class="label label-danger"><?= h($log["kind"]) ?></span></td>
	<?php else: ?>
			<td><?= h($log["kind"]) ?></td>
	<?php endif ?>
			<td><?= h($log["name"]) ?></td>
			<td><?= h($log["message"]) ?></td>
			<td><?= h($log["createdAt"]) ?></td>
		</td>
<?php endforeach ?>
	</tbody>
</table><!-- /table -->

<?php $this->include_template('include/footer.tpl') ?>
