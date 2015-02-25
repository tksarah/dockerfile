# Dockerfile
## nfs-connector
### clustered Data ONTAP セットアップ
### Docker Container セットアップ

1. Dockerfileダウンロード

`$ git clone https://github.com/tksarah/dockerfile.git`
2. core-site.xmlとnfs-mapping.jsonを編集

`$ cd dockerfile/nfs-connector/`

Dockerイメージのビルド

`$ docker build -t hoge/fuga .`

Dockerコンテナ起動

`$ docker run -itd -p 8088:8088 -p 80:2812 --name demo hoge/fuga`

確認
```
$ docker exec -it demo hadoop fs -ls /
Store with ep Endpoint: host=nfs://192.168.0.60:2049/ export=/ path=/ has fsId 2147484673
Found 6 items
drwxrwxrwx   - root root       4096 2015-02-23 17:05 /.snapshot
drwxr-xr-x   - root root       4096 2015-02-23 14:24 /hadoopvol01
drwxr-xr-x   - root root       4096 2015-02-23 16:51 /hadoopvol02
```

Monit
 http://192.168.0.123/
Hadoop
 http://192.168.0.123:8088/

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```
