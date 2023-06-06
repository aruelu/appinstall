# appinstallの機能
下記の機能があります。
- aptでインストール
- flatpakでインストール
- flatpakで探してインストール
- flatpakの文字化け改善※
- flatpakのソフト起動※
- flatpakのソフト更新※
- flatpakの全てのソフト更新
- flatpakのソフト削除※

※が付いた機能はappinstallでインストールしたソフトが対象になります。

# 使用方法

## 準備
```
./setup.sh
```
 
## 実行
```
./appinstall
```

# 設定ファイル１

apt.conf


## 設定内容

ID ソフト名 説明 パッケージ１,パッケージ２・・・

区切は半角スペース、複数パッケージの場合、「,」で区切る

# 設定ファイル２

flatpak.conf

## 設定内容

ID ソフト名 説明 remotes,アプリケーションID

区切は半角スペース、remotesとアプリケーションIDは「,」で区切る
