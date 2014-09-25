# Japanese Wrap Package

Word wrap for Japanese text.

The following text is written in Japanese, because this package is made for Japanese users. If you do not understand Japanese, this package is worthless.

# 日本語用ワードラップパッケージ
このパッケージは日本語文章での、画面幅(または指定文字数)での改行処理を行うAtomのパッケージです。標準のSoft Wrap機能を上書きする形となり、改行の際には下記処理を行います。

* 英文のみの場合は標準のSoft Wrapとほぼ同じ処理をします。
* 2倍幅の文字(主にShfit_JISにおける2バイト文字)を2倍幅で計算します。
* 日本語における禁則処理を行います。

文字コードに関してはUnicode 7.0を参照しています。Unicodeのバージョンが上がった場合はその都度対応予定です。禁則処理はW3Cの「日本語組版処理の要件」を参考にしています。

## 使い方
1. Atom標準のSoft Wrapを有効にします。関連のある設定は下記になります。
    * Preferred Line Length
    * Soft Wrap
    * Soft Wrap At Preferred Line Length
2. パッケージをインストールします。
3. Atomの表示を再読み込みします。うまく反映されない場合は再起動してみてください。

無効にする場合は、パッケージをDisabledにするか、Uninstallしてください。なお、標準のSoft Wrapが無効の場合は、ラップ機能は動作しません。

## ！！動きません！！という方は
本パッケージはAtomの非標準APIを使用しています。Atom本体は常に開発されているため、DisplayBufferのSoft Wrap周りが変更されると動かないことがあります。現バージョン(v0.2.0)はv0.131.0で確認しています。最低そこまではアップデートしてみてください。

その他の情報はgithub内の下記Wikiを参照してください。

https://github.com/raccy/japanese-wrap/wiki
