<?php $this->include_template('include/header.tpl') ?>
<?php $this->include_template('include/breadcrumb.tpl') ?>

<div class="page-header">
	<h1>help <small>使い方</small></h1>
</div>

<p>ここでは、NicoKakoの使い方をごく簡単に紹介します。</p>

<div class="page-header">
	<h2>introduction <small>はじめに</small></h2>
</div>

<p>NicoKakoは、ニコニコ生放送のタイムシフト動画をダウンロードするためのウェブアプリです。</p>
<p>次の3ステップで利用が可能です。</p>

<ol>
	<li>放送を登録する<ul>
		<li><a href="<?= h($this->get_url('register')) ?>">register</a>から放送を登録します。</li>
		<li>登録に必要なものは、放送のURLだけです。</li>
		<li>登録前にタイムシフト予約をする必要があります。</li>
	</ul></li>
	<li>ダウンロードを待つ<ul>
		<li>NicoKakoが自動的に放送情報を取得し、ダウンロードを開始します。</li>
		<li>完了までに時間が掛かるので、しばらく待ちます。</li>
	</ul></li>
	<li>放送を閲覧する<ul>
		<li><a href="<?= h($this->config["application_url"]) ?>">index</a>からダウンロードが完了した放送を閲覧できます。</li>
		<li>サムネイルが「NOW DOWNLOADING」になっているものは、現在処理中です。</li>
	</ul></li>
</ol>

<p>とっても簡単ですね！</p>

<div id="index" class="page-header">
	<h2>index <small>放送を閲覧する</small></h2>
</div>

<ol>
	<li><a href="<?= h($this->config["application_url"]) ?>">index</a>にアクセスする。<ul>
		<li>画面下部に利用可能な放送のリストが表示されます。</li>
	</ul></li>
	<li>「lives」の中から好きな放送のサムネイルをクリックする。<ul>
		<li>プレイヤーの再生ボタンをクリックすると再生が開始されます。</li>
	</ul></li>
</ol>

<div id="register" class="page-header">
	<h2>register <small>放送を登録する</small></h2>
</div>

<ol>
	<li><a href="<?= h($this->get_url("register")) ?>">register</a>にアクセスする。<ul>
		<li>URLの入力欄が表示されます。</li>
	</ul></li>
	<li>入力欄に登録したい放送のURLを入力して「確認する」をクリックする。<ul>
		<li>URLが正しければ、放送のタイトルなどが抽出され、画面に表示されます。</li>
		<li>エラーの場合は、正しいURLを入力しなおして再度「確認する」をクリックしてください。</li>
	</ul></li>
	<li>タイトルなどを確認し、「登録する」をクリックする。<ul>
		<li>成功であれば登録は完了です。</li>
		<li>失敗した場合は最初からやり直してください。</li>
		<li>「失敗」の表示が繰り返し出るようであれば、詳しい状況とともに管理者へ報告をお願いします。</li>
	</ul></li>
</ol>

<?php $this->include_template('include/footer.tpl') ?>
