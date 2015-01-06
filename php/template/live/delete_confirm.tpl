<?php
	$live = $this->get("live");
?>

<div class="page-header">
	<h2>confirm <small>確認</small></h2>
</div>

<form action="<?= h($this->get_url()) ?>" method="post" role="form">
	<fieldset disabled="disabled">
		<div class="form-group">
			<label>タイトル</label>
			<input type="text" value="<?= h($live['title']) ?>" class="form-control" />
		</div>
	</fieldset>
	<button name="submit" type="submit" class="btn btn-danger">タイトルを本当に削除する</button>
</form>
