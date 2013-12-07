<?php
	$is_valid = $this->get("is_valid");
	$validation_error = $this->get("validation_error");

	if ($is_valid) {
		$group_class = "form-group";
	} else {
		$group_class = "form-group has-error";
	}
?>

<div class="page-header">
	<h2>input <small>入力</small></h2>
</div>

<form action="<?= h($this->get_url()) ?>" method="post" role="form">
	<div class="<?= h($group_class) ?>">
		<label for="url">URL</label>
		<input name="url" type="text" value="<?= h($this->post["url"]) ?>" class="form-control" id="url" placeholder="http://live.nicovideo.jp/watch/lvxxxx" />
<?php if (!$is_valid): ?>
		<p class="help-block">
			<?= nl2br_h(implode("\n", $validation_error)) ?>
		</p>
<?php endif ?>
	</div>
	<button name="confirm" type="submit" class="btn btn-primary">確認する</button>
</form>
