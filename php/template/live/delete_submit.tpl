<?php
	$is_valid = $this->get("is_valid");
	$validation_error = $this->get("validation_error");
	$is_success = $this->get("is_success");
	$submission_error = $this->get("submission_error");
?>

<div class="page-header">
	<h2>submit <small>提出</small></h2>
</div>

<?php if ($is_valid && $is_success): ?>
<div class="alert alert-success">
	削除が完了しました。
	<span class="label label-success">成功</span>
</div>
<?php elseif ($is_valid): ?>
<div class="alert alert-danger">
	<?= nl2br_h(implode("\n", $submission_error)) ?> 
	<span class="label label-danger">失敗（データベース）</span>
</div>
<?php else: ?>
<div class="alert alert-danger">
	<?= nl2br_h(implode("\n", $validation_error)) ?> 
	<span class="label label-danger">失敗（入力検査）</span>
</div>
<?php endif ?>

<p>
	<a class="btn btn-primary" href="<?= h($this->config["application_url"]) ?>">戻る</a>
</p>
