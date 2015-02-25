# Dockerfile
## nfs-connector

Dockerfileダウンロード

`$ git clone https://github.com/tksarah/dockerfile.git`


core-site.xmlとnfs-mapping.jsonを編集

`$ cd dockerfile/nfs-connector/`

> Blogck Quotes
> Block 2


```
$ docker build -t hoge/fuga .

$ docker run -itd -p 8088:8088 -p 80:2812 --name demo hoge/fuga

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

