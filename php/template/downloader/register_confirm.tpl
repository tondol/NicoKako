<?php
	$live_id = $this->get("live_id");
	$live_title = $this->get("live_title");
	$params = $this->get("params");
?>

<div class="page-header">
	<h2>confirm <small>確認</small></h2>
</div>

<form action="<?= h($this->get_url()) ?>" method="post" role="form">
	<fieldset disabled="disabled">
		<div class="form-group">
			<label>ID</label>
			<input type="text" value="<?= h($live_id) ?>" class="form-control" />
		</div>
		<div class="form-group">
			<label>タイトル</label>
			<input type="text" value="<?= h($live_title) ?>" class="form-control" />
		</div>
		<div class="form-group">
			<label>ファイル名</label>
<?php foreach ($params["contents"] as $content): ?>
			<input type="text" value="<?= h($content["playpath"]) ?>" class="form-control" />
<?php endforeach ?>
		</div>
		<div class="checkbox" style="margin-top: -5px">
			<label>
				<input type="checkbox" <?= isset($this->post["timeshift"]) && !empty($this->post["timeshift"]) ? 'checked="checked"' : '' ?> />
				タイムシフト予約する
			</label>
		</div>
	</fieldset>
	<input name="url" type="hidden" value="<?= h($this->post["url"]) ?>" />
	<input name="timeshift" type="hidden" value="<?= h($this->post["timeshift"]) ?>" />
	<button name="submit" type="submit" class="btn btn-primary">登録する</button>
	<button name="default" type="submit" class="btn btn-default">戻る</button>
</form>
