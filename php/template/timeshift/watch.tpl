<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<div class="page-header">
	<h1><?= h($this->get_title()) ?> <small>タイムシフトのアクティベート</small></h1>
</div>

<?php
	$is_valid = $this->get("is_valid");
	$is_success = $this->get("is_success");

	if (isset($this->post["submit"])) {
		$this->include_template("timeshift/watch_submit.tpl");
	} else {
		$this->include_template("timeshift/watch_confirm.tpl");
	}
?>

<?php $this->include_template('include/footer.tpl') ?>
