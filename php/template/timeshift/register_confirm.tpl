<?php
	$live_id = $this->get("live_id");
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
	</fieldset>
	<input name="url" type="hidden" value="<?= h($this->post["url"]) ?>" />
	<button name="submit" type="submit" class="btn btn-primary">予約する</button>
	<button name="default" type="submit" class="btn btn-default">戻る</button>
</form>
