# google-home-voicetext-docker

`google-home-voicetext`を動かすためのDocker環境です。

参考URL

https://github.com/sikkimtemi/google-home-voicetext

## 事前準備

### VoiceTextのAPIキーを取得

下記URLから無料利用登録を行い、APIキーを取得してください。

https://cloud.voicetext.jp/webapi


### Firebaseの秘密鍵を取得

Firebaseのコンソールで`設定（歯車アイコン）->プロジェクトの設定->サービスアカウント`を表示し、`新しい秘密鍵の生成`をクリックしてください。

ダウンロードしたJSONファイルを`firebase.json`にリネームし、`Dockerfile`と同じパスに配置してください。

また、「Admin SDK 構成スニペット」のNode.jsに記載された`databaseURL`の値を控えておいてください。

### Cloud Firestoreに連携用フィールドを作成

FirebaseのコンソールでCloud Firestoreを開き、`コレクションを追加`をクリックし、コレクションIDに`googlehome`と入力してください。

ドキュメントIDに`chant`、フィールドに`message`と入力して保存してください。

google-home-voicetextはこのフィールドを監視し、入力された言葉をGoogle Homeで再生します。

ルールは下記のように設定してください。

```
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### 設定ファイル(`.my.env`)の準備

`.my.env.sample`をコピーして`.my.env`にリネームしてください。

下記を参考に値を設定してください。

|変数名|説明|
|- |- |
|TZ|タイムゾーン|
|VOICETEXT_API_KEY|VoiceTextのAPIキー|
|WIRELESS_IP|Dockerを動かすホストのIPアドレス。複数のIPアドレスが存在する場合は、Google HomeからアクセスできるIPを記述する。|
|GOOGLE_HOME_IP|Google HomeのIPアドレス|
|FIREBASE_DATABASE_URL|「Admin SDK 構成スニペット」の`databaseURL`の値|
|FIREBASE_SECRET_KEY_PATH|この値は変更しないでください。|
|VOICETEXT_SPEAKER|話者一覧を参照(https://cloud.voicetext.jp/webapi/docs/api)|


### Dockerコンテナの起動

```bash
$ docker-compose up -d
```


### 動作確認

同一ネットワークからAPI呼び出しを行う場合は以下のようにします。

```bash
$ curl -X POST -d "text=こんにちは、Googleです。" http://{DockerのIPアドレス}:8080/google-home-voicetext
```

Firebaseから呼び出す場合は、事前準備でCloud Firestoreに作成した`googlehome > chant > message`フィールドに日本語を入力してください。

Google Homeから入力した言葉が聞こえたら成功です。

## Dockerコンテナの終了

```bash
$ docker-compose down
```
