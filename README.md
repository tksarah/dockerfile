# Dockerfile
## nfs-connector
### clustered Data ONTAP Setup

1. Create SVM with NFS access
2. Create a volume in the SVM
3. Create at least LIF with data access to the volume from NodeManager
4. Disable the nfs-rootonly and mount-rootonly options to SVM

```
cdot-01::> vserver nfs modify -vserver nfsdrivervserver -nfs-rootonly disabled
cdot-01::> vserver nfs modify -vserver nfsdrivervserver -mount-rootonly disabled

```
5. Increase the NFS read message size to 1MB and the write size to 65536 bytes

```
cdot-01::> set advanced
Warning: These advanced commands are potentially dangerous; use them only when directed to do so by NetApp personnel.
Do you want to continue? {y|n}: y
cdot-01::*> vserver nfs modify -vserver nfsdrivervserver -v3-tcp-max-read-size 1048576
cdot-01::*> vserver nfs modify -vserver nfsdrivervserver -v3-tcp-max-write-size 65536

```

### Docker Container Setup

Dockerfile download

`$ git clone https://github.com/tksarah/dockerfile.git`

Edit **core-site.xml** and **nfs-mapping.json**

`$ cd dockerfile/nfs-connector/`

Example;
* Edit a value of **fs.defaultFS**

```xml
# core-site.xml
<configuration>

  <!-- NetApp NFS Connector Setting -->
  <property>
    <name>fs.nfs.prefetch</name>
    <value>true</value>
  </property>

  <property>
    <name>fs.defaultFS</name>
    <value>nfs://node01-ip01:2049</value>
  </property>

  <property>
    <name>fs.AbstractFileSystem.nfs.impl</name>
    <value>org.apache.hadoop.fs.nfs.NFSv3AbstractFilesystem</value>
  </property>

  <property>
    <name>fs.nfs.impl</name>
    <value>org.apache.hadoop.fs.nfs.NFSv3FileSystem</value>
  </property>

  <property>
    <name>fs.nfs.configuration</name>
    <value>/etc/hadoop/conf/nfs-mapping.json</value>
  </property>
```

Example;
* Edit a value of **spaces : uri**
* Edit a value of **spaces : options : nfsExportPath**
* Edit values of **spaces : endpoints : host,path**

```json
# nfs-mapping.json file
{
        "spaces": [
                {
                "name": "ntap",
                "uri": "nfs:/node01-ip01/:2049/",
                "options": {
                        "nfsExportPath": "/",
                        "nfsReadSizeBits": 20,
                        "nfsWriteSizeBits": 20,
                        "nfsSplitSizeBits": 30,
                        "nfsAuthScheme": "AUTH_NONE",
                        "nfsUsername": "root",
                        "nfsGroupname": "root",
                        "nfsUid": 0,
                        "nfsGid": 0,
                        "nfsPort": 2049,
                        "nfsMountPort": -1,
                        "nfsRpcbindPort": 111
                },
                "endpoints": [
                        {
                        "host": "nfs://node01-ip01:2049/",
                        "path": "/vol01/"
                        },
                        {
                        "host": "nfs://node01-ip02:2049/",
                        "path": "/vol02/"
                        }
                ]
                }
        ]
}
```

Build the docker image

`$ docker build -t hoge/fuga .`

Run the docker container

`$ docker run -itd -p 8088:8088 -p 80:2812 --name demo hoge/fuga`

Verify 
```
$ docker exec -it demo hadoop fs -ls /
Store with ep Endpoint: host=nfs://192.168.0.60:2049/ export=/ path=/ has fsId 2147484673
Found 6 items
drwxrwxrwx   - root root       4096 2015-02-23 17:05 /.snapshot
drwxr-xr-x   - root root       4096 2015-02-23 14:24 /hadoopvol01
drwxr-xr-x   - root root       4096 2015-02-23 16:51 /hadoopvol02
```
Access on Browser 

* Monit
 * http://*your docker host ip address*/
* Hadoop
 * http://*your docker host ip address*:8088/


