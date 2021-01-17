# docker-nginx-hls

HLS配信用サーバを動作させるDockerイメージ

## 使い方

DockerでHLS配信用サーバを起動します。
```shell
docker run --rm -p 80:80 -p 1935:1935 aplulu/nginx-hls 
```

OBS Studioなどのライブ配信ツールでサーバを `rtmp://[DockerホストのIPアドレス]/hls` ストリームキー `live` として設定してストリームを開始します。

下記のURLを使用して閲覧します。
* ブラウザ用視聴用URL: `http://[DockerホストのIPアドレス]`
* VRChat内のiwaSyncVideoなど用URL: `http://[DockerホストのIPアドレス]/hls/live.m3u8`

ローカルネットワーク外から視聴できるようにするためにはDockerホストのIPアドレスのTCP 80番ポートを外部に開放する必要があります。(TCP 1925番ポートは開放する必要はありません。)
