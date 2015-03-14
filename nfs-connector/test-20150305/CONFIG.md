# Demonstration for NFS Connector

Details : [NetApp Hadoop NFS Connector](https://github.com/NetApp/NetApp-Hadoop-NFS-Connector)


##Table of contents

 * [Setup clustered Data ONTAP](#cdot)
 * [Setup Docker Container](#cont)
 * [Try NFS Connector](#try)
 * [Test Job](#test)

<a name="cdot"></a>
##Setup clustered Data ONTAP

* Create SVM with NFS access
* Create some volumes in the SVM
* Set 777 unix permission for junction path of volumes
* Create at least LIF with data access to the volume from NodeManager
* Disable the nfs-rootonly and mount-rootonly options to SVM
```
cdot-01::> vserver nfs modify -vserver nfstestserver -nfs-rootonly disabled
cdot-01::> vserver nfs modify -vserver nfstestserver -mount-rootonly disabled
```
* Increase the NFS read message size to 1MB and the write size to 65536 bytes

```
cdot-01::> set advanced
Warning: These advanced commands are potentially dangerous; use them only when directed to do so by NetApp personnel.
Do you want to continue? {y|n}: y
cdot-01::*> vserver nfs modify -vserver nfstestserver -v3-tcp-max-read-size 1048576
cdot-01::*> vserver nfs modify -vserver nfstestserver -v3-tcp-max-write-size 65536
```

<a name="cont"></a>
##Setup Docker Container 

Dockerfile download
```
$ git clone https://github.com/tksarah/dockerfile.git
```

Edit **core-site.xml** and **nfs-mapping.json**
```
$ cd dockerfile/nfs-connector/test-20150305
```

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
* Edit two values of **spaces : endpoints : host,path**

```json
# nfs-mapping.json file
{
        "spaces": [
                {
                "name": "ntap",
                "uri": "nfs://node01-ip01:2049/",
                "options": {
                        "nfsExportPath": "/",
                        "nfsReadSizeBits": 20,
                        "nfsWriteSizeBits": 20,
                        "nfsSplitSizeBits": 30,
                        "nfsAuthScheme": "AUTH_SYS",
                        "nfsUsername": "root",
                        "nfsGroupname": "root",
                        "nfsUid": 0,
                        "nfsGid": 0,
                        "nfsUserConfigFile": "/etc/hadoop/conf/nfs-users.json",
                        "nfsGroupConfigFile": "/etc/hadoop/conf/nfs-groups.json",
                        "nfsPort": 2049,
                        "nfsMountPort": -1,
                        "nfsRpcbindPort": 111
                },
                "endpoints": [
                        {
                        "host": "nfs://node01-ip01:2049/",
                        "path": "/htop/hadoopvol1/"
                        },
                        {
                        "host": "nfs://node01-ip02:2049/",
                        "path": "/htop/hadoopvol2/"
                        }
                ]
                }
        ]
}
```
Build a docker image
```
$ docker build -t hoge/fuga .
```
Run a container
```
$ docker run --rm -i -t --name demo -p 8088:8088 hoge/fuga
```
or
```
$ docker run --rm -i -t --name demo -p 8088:8088 hoge/fuga /sbin/my_init -- bash -l
``` 

Verification 
```
$ docker exec -it demo hadoop fs -ls /
Store with ep Endpoint: host=nfs://192.168.0.60:2049/ export=/ path=/ has fsId 2147484673
Found 3 items
drwxrwxrwx   - root root       4096 2015-02-23 17:05 /.snapshot
drwxr-xr-x   - root root       4096 2015-02-23 14:24 /hadoopvol01
drwxr-xr-x   - root root       4096 2015-02-23 16:51 /hadoopvol02
```

<a name="try"></a>
##Try NFS Connector


Try TeraGen
```
$ docker exec -it demo bash
$ yarn jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar teragen 10000 /hadoopvol1/data1MB
Store with ep Endpoint: host=nfs://192.168.0.60:2049/ export=/htop path=/ has fsId 2147484677
15/02/25 02:33:31 INFO nfs.NFSv3FileSystem: getAndVerifyHandle(): Parent path nfs://192.168.0.60:2049/hadoopvol01 could not be found
15/02/25 02:33:31 INFO client.RMProxy: Connecting to ResourceManager at /0.0.0.0:8032
15/02/25 02:33:32 WARN stream.NFSBufferedOutputStream: Flushing a closed stream. Check your code.
15/02/25 02:33:32 INFO stream.NFSBufferedOutputStream: STREAMSTATSstreamStatistics:
STREAMSTATS     name: class org.apache.hadoop.fs.nfs.stream.NFSBufferedInputStream/tmp/hadoop-yarn/staging/root/.staging/job_1424831424592_0001/job.jar

....

        org.apache.hadoop.examples.terasort.TeraGen$Counters
                CHECKSUM=21555350172850
        File Input Format Counters
                Bytes Read=0
        File Output Format Counters
                Bytes Written=1000000
$ 

$ hadoop fs -ls -R /hadoopvol1/
Store with ep Endpoint: host=nfs://192.168.0.60:2049/ export=/htop path=/ has fsId 2147484677
Store with ep Endpoint: host=nfs://192.168.0.60:2049/ export=null path=/hadoopvol1/ has fsId 2147484677
drwxrwxrwx   - root root       4096 2015-02-25 03:07 /hadoopvol1/data1MB
-rw-r--r--   1 root root          0 2015-02-25 03:07 /hadoopvol1/data1MB/_SUCCESS
-rw-r--r--   1 root root     500000 2015-02-25 03:07 /hadoopvol1/data1MB/part-m-00000
-rw-r--r--   1 root root     500000 2015-02-25 03:07 /hadoopvol1/data1MB/part-m-00001
```
Stop a container
```
$ docker stop demo
```
