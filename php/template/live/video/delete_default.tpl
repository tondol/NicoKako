<?php
	$live = $this->get("live");
	$video = $this->get("video");
	$is_valid = $this->get("is_valid");
	$validation_error = $this->get("validation_error");
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
		<div class="form-group">
			<label>ファイル名</label>
			<input type="text" value="<?= h($video['filename']) ?>" class="form-control" />
		</div>
	</fieldset>
<?php if (!$is_valid): ?>
	<div class="form-group has-error">
		<p class="help-block">
			<?= nl2br_h(implode("\n", $validation_error)) ?>
		</p>
	</div>
<?php endif ?>
	<button name="confirm" type="submit" class="btn btn-primary">確認する</button>
</form>
