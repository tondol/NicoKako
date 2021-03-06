NicoKako
====

NicoKakoはニコニコ生放送のタイムシフト動画をダウンロードすることのできるウェブアプリです。

Requirements
----

- Ruby（Version 1.9 もしくはそれ以降）
    - Nokogiri
    - Ruby/MySQL
    - Bundler
- PHP（Version 5.3 もしくはそれ以降）
    - DOM
    - JSON
    - PDO (MySQL)
- MySQL

Install
----

いくつかのステップが必要です。

（将来的に実行環境をDockerfileとして提供したいと思っています。）

### rtmpdumpの導入

rtmpeプロトコルの動画をダウンロードするため，
下記のようにして[rtmpdump](http://rtmpdump.mplayerhq.hu/)を導入します。
rtmpdumpの実行ファイルはパスの通っている場所に配置する必要があります。

~~~~
$ cd ~/tmp
$ git clone git://git.ffmpeg.org/rtmpdump
$ cd ~/tmp/rtmpdump
$ ./configure
$ make
$ sudo make install
~~~~

### 必要なファイル郡の設置

~~~~
$ git clone https://github.com/tondol/NicoKako.git ~/www/nicokako
$ cd ~/www/nicokako
$ git submodule update --init
~~~~

### インストールスクリプトの実行

~~~~
$ ./install.sh
~~~~

足りないものがある場合はインストールする旨のメッセージが出力され，終了します。
必要なコマンド等が揃っていれば，設定入力のプロンプトが表示されるので，各項目を入力してください。
無事完了すれば，必要なgemのインストールやテーブルの作成等が自動で行われます。

### apache/nginxの設定

`<設置したパス>/public`をドキュメントルートとして設定します。
Pretty URLs対応のため，適宜URLのリダイレクト設定を行う必要があります。

```
your_app/foo/bar -> your_app/index.php?chain=foo/bar
```

**Basic認証などの方法によりアクセス制限の設定を追加すること**を強くお薦めします。

### crontabの設定

`ruby/downloader.rb`を定期実行するように設定します。

~~~~
$ crontab -e
~~~~

~~~~
# 記述例

SHELL=/bin/bash
HOME=/home/fuga
MAILTO=""

# nicokako
NICOKAKO_DIR=/home/fuga/www/nicokako/ruby
0 * * * * ruby $NICOKAKO_DIR/downloader.rb >> $NICOKAKO_DIR/nicokako.log 2>> $NICOKAKO_DIR/error.log
~~~~

### 注）apacheのプロセスからRubyスクリプトを実行する

Rubyをユーザーのホームディレクトリ以下にインストールしているようなケース
（たとえば，rbenvを公式のチュートリアルに従いインストールしているとき）では，
PHP側からのRubyスクリプトの呼び出し部分がうまく動かないことがあります。
そのようなケースでは，`/etc/sysconfig/httpd`もしくは`/etc/apache2/envvars`を編集し，
apacheプロセス実行時のPATHに適宜ディレクトリを追加してください。

~~~~
# 記述例
export PATH=/home/fuga/.rbenv/shims:$PATH
~~~~

場合によりディレクトリのパーミッションを変更する必要もあるかもしれません。
また，設定ファイル編集後にApacheを再起動することにも留意してください。

HOW TO USE
----

`<設置先URL>/help/`をブラウザで閲覧してください。
