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
			<p class="help-block">予約が「視聴可能」になるまでに少し時間が掛かることがあります。</p>
		</div>
	</fieldset>
	<button name="submit" type="submit" class="btn btn-primary">アクティベートする</button>
</form>
