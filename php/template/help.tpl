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
	<li>ダウンロード対象を登録する<ul>
		<li><a href="<?= h($this->get_url("downloader/register")) ?>">downloader/register</a>からタイトルを登録します。</li>
		<li>登録に必要なものは、対象となる生放送のURLだけです。</li>
		<li>登録前にタイムシフト予約をする必要があります。</li>
	</ul></li>
	<li>ダウンロードを待つ<ul>
		<li>NicoKakoが自動的にタイトル情報を取得し、ダウンロードを開始します。</li>
		<li>完了までに時間が掛かるので、しばらく待ちます。</li>
	</ul></li>
	<li>タイトルを閲覧する<ul>
		<li><a href="<?= h($this->get_url("index")) ?>">index</a>からダウンロードが完了したタイトルを閲覧できます。</li>
		<li>サムネイルが「NOW DOWNLOADING」になっているものは、現在処理中です。</li>
	</ul></li>
</ol>

<p>とっても簡単ですね！</p>

<div id="index" class="page-header">
	<h2>index <small>放送を閲覧する</small></h2>
</div>

<ol>
	<li><a href="<?= h($this->get_url("index")) ?>">index</a>にアクセスする<ul>
		<li>画面下部に利用可能な放送のリストが表示されます。</li>
	</ul></li>
	<li>「lives」の中から好きな放送のサムネイルをクリックする<ul>
		<li>画面下部に閲覧可能な放送のリストが表示されます。</li>
	</ul></li>
	<li>「videos」の中から好きな動画のサムネイルをクリックする<ul>
		<li>プレイヤーの再生ボタンをクリックすると再生が開始されます。</li>
		<li>携帯端末では「動画のダウンロード」をタップすることで再生が可能です（一部ファイルは非対応）。</li>
	</ul></li>
</ol>

<div id="downloader" class="page-header">
	<h2>downloader <small>ダウンロード対象を登録する</small></h2>
</div>

<ol>
	<li><a href="<?= h($this->get_url("downloader/register")) ?>">downloader/register</a>にアクセスする<ul>
		<li>URLの入力欄が表示されます。</li>
		<li>タイムシフト予約を自動で行うには「タイムシフト予約する」をチェックします。</li>
	</ul></li>
	<li>入力欄に登録したい放送のURLを入力して「確認する」をクリックする<ul>
		<li>URLが正しければ、タイトルなどが抽出され、画面に表示されます。</li>
		<li>エラーの場合は、正しいURLを入力しなおして再度「確認する」をクリックしてください。</li>
	</ul></li>
	<li>タイトルなどを確認し、「登録する」をクリックする<ul>
		<li>成功であれば登録は完了です。</li>
		<li>失敗した場合は最初からやり直してください。</li>
		<li>「失敗」の表示が繰り返し出るようであれば、詳しい状況とともに管理者へ報告をお願いします。</li>
	</ul></li>
</ol>

<div id="timeshift" class="page-header">
	<h2>timeshift <small>タイムシフト予約を管理する</small></h2>
</div>

<p>これまで，放送をアーカイブするにはニコニコ動画側で予めタイムシフト予約と視聴を一度行う必要がありましたが、
タイムシフト予約を管理する機能が実装されたことにより、
アプリ単体でアーカイブが可能になりました。</p>
<p>次のような手順で操作します。</p>

<ol>
	<li>タイムシフト予約する<ul>
		<li><a href="<?= h($this->get_url("timeshift/register")) ?>">timeshift/register</a>に放送のURLを入力してタイムシフト予約します。</li>
		<li>既に予約済みの場合はこの操作は不要です。</li>
	</ul></li>
	<li>アクティベート（視聴）する<ul>
		<li><a href="<?= h($this->get_url("timeshift")) ?>">timeshift</a>にアクセスします。</li>
		<li>アーカイブしたい放送の「アクティベート」をクリックします。</li>
		<li>「アクティベートする」をクリックしてアクティベートを完了します。</li>
		<li>アクティベート（視聴）は1回のみしか実行できず、
		視聴期間が過ぎるとアーカイブ不能となるので注意してください。</li>
	</ul></li>
	<li>（必要に応じて）タイムシフト予約を削除する<ul>
		<li><a href="<?= h($this->get_url("timeshift")) ?>">timeshift</a>にアクセスします。</li>
		<li>不要となった放送の「削除」をクリックします。</li>
		<li>「削除する」をクリックするとタイムシフト予約を解除（一覧から削除）できます。</li>
	</ul></li>
</ol>

<p>少々ややこしいですが、
「予約」「視聴」の操作はニコニコ動画上で行うものと同じなので、
不明な点があれば<a href="http://dic.nicovideo.jp/a/%E3%82%BF%E3%82%A4%E3%83%A0%E3%82%B7%E3%83%95%E3%83%88%E6%A9%9F%E8%83%BD">ニコニコ大百科の記事</a>を参照してください。</p>

<?php $this->include_template('include/footer.tpl') ?>
