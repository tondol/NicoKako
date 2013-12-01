<?php
	$links = array();
	$stack = array();

	$main = $this->config["application_main"];
	if ($this->get_chain() != $main) {
		$name = $this->get_name($main);
		$url = $this->get_url($main);
		$links[] = "<a href=\"" . $url . "\">" . $name . "</a>";
	}

	$exploded = explode(DIRECTORY_SEPARATOR, $this->get_chain());
	foreach ($exploded as $value) {
		array_push($stack, $value);
		$chain = implode(DIRECTORY_SEPARATOR, $stack);

		$name = $this->get_name($chain);
		$url = $this->get_url($chain);
		$links[] = "<a href=\"" . $url . "\">" . $name . "</a>";
	}
?>
<ul class="breadcrumb">
	<li><?= implode("</li>&nbsp;<li>", $links) ?></li>
</ul><!-- /breadcrumb -->
