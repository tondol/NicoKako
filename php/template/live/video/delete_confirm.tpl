<?php
	$live = $this->get("live");
	$video = $this->get("video");
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
	<button name="submit" type="submit" class="btn btn-danger">動画を本当に削除する</button>
	<button name="default" type="submit" class="btn btn-default">戻る</button>
</form>
