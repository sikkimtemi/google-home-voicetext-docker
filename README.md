# google-home-voicetext-docker
`google-home-voicetext`を動かすためのDocker環境です。

# 使い方
## Dockerコンテナの起動

```bash
$ git clone https://github.com/sikkimtemi/google-home-voicetext-docker.git
$ cd google-home-voicetext-docker
$ docker-compose up -d
```

## google-home-voicetextのインストール

### ソースコードのダウンロード

```bash
$ cd myapps
$ git clone https://github.com/sikkimtemi/google-home-voicetext.git
```

ホスト側の`myapps`ディレクトリはコンテナ内部の`/myapps`にマウントされています。

### コンテナに接続

```bash
$ docker exec -it node bash
```

以降の操作はコンテナ内部で行います。

### npmインストール

```bash
# cd google-home-voicetext
# npm install
```

### mdnsにパッチをあてる

```bash
# patch -u node_modules/mdns/lib/browser.js < mdns_patch/browser.js.patch
```

### 環境変数の設定

```bash
# export VOICETEXT_API_KEY=...
# export WIRELESS_IP=...
# export GOOGLE_HOME_IP=...
```

設定する環境変数の内容については`google-home-voicetext`のREADMEを参照してください。

環境変数はコンテナを終了するとクリアされます。永続的に設定したい場合は、`docker-compose.yml`の`environment`に追加してください。

### mdns関連のサービス起動

```bash
# service dbus start
# service avahi-daemon start
```

これらのサービスを起動しておかないとmdnsがエラーになります。

### file-server.jsとapi-server.jsを起動

```bash
# node file-server.js &
# node api-server.js &
```

### コンテナから抜ける

```bash
# exit
```

## 動作確認

```bash
$ curl -X POST -d "text=こんにちは、Googleです。" http://{DockerのIPアドレス}:8080/google-home-voicetext
```

## コンテナの終了

```bash
$ docker-compose down
```