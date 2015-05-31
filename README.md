# Japanese Wrap Package

Word wrap for Japanese text (and may little help Chinese and Korean).

This package makes a correct soft wrap, if you use the double-width characters. And it considers breaking rules for Japanese.

## Abount the future

Atom 1.0 roadmap includes a task to fix [atom/atom#1783](https://github.com/atom/atom/issues/1783) that is the bug fixed by this package. So it will not be needed in the future! But the fix may not support miner breaking rules used for Japanese only. If so, I'll recreate this package, maybe.

## Monospace font only

This package assumes the use of monospace fonts. If you use proportional fonts, it is better to use [atomicchar](https://atom.io/packages/atomicchar) forked by this package.

## For Chinese and Korean users

This package does not correspond to Chinese or Korean. But if you may ignore the line breaking rule, it's useful. Please disable the setting "日本語禁則処理を行う" (to use the line breaking rule for Japanese).

And see also [atomicchar](https://atom.io/packages/atomicchar).

# 日本語用ワードラップパッケージ
本パッケージは日本語文章での、画面幅(または指定文字数)での改行処理を行うAtomのパッケージです。標準のSoft Wrap機能を上書きする形となり、改行の際には下記処理を行います。

* 英文のみの場合は標準のSoft Wrapとほぼ同じ処理をします。
* 2倍幅の文字(主にShfit_JISにおける2バイト文字)を2倍幅で計算します。
* 日本語における禁則処理を行います。

文字コードに関してはUnicode 7.0を参照しています。禁則処理はW3Cの「日本語組版処理の要件」を参考にしています。

## 使い方
1. Atom標準のSoft Wrapを有効にします。関連のある設定は下記になります。
    * Preferred Line Length
    * Soft Wrap
    * Soft Wrap At Preferred Line Length
2. パッケージをインストールします。

無効にする場合は、パッケージをDisabledにするか、Uninstallしてください。なお、標準のSoft Wrapが無効の場合は、ラップ機能は動作しませんので、ご注意ください。

## 動かないときは？
本パッケージはAtomの非標準APIを使用しています。Atom本体は常に開発されているため、DisplayBufferのSoft Wrap周りが変更されると動かないことがあります。うまく動作しない場合は、最新へアップデートしてみてください。現バージョン(v0.2.9)はv0.204.0で確認し、新しい1.0 APIsとchorme 41に対応しています。

## その他
本パッケージは等幅フォント専用です。プロポーショナルフォントを使いたい場合は、[atomicchar](https://atom.io/packages/atomicchar)を使ってみてください。

Atom 1.0 では本パッケージの修正部分が対応されるため、不要になる予定です。ただし、マイナーな禁則処理の対応に特化したものに作り直すかもしれません。
