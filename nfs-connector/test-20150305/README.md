# Demonstration for NFS Connector

Details : [NetApp Hadoop NFS Connector](https://github.com/NetApp/NetApp-Hadoop-NFS-Connector)


##Table of contents

 * [Demo Enviromnent](#env)
 * [Setup Docker Container](#cont)
 * [Try NFS Connector](#try)
 * [Test Job](#test)

<a name="env"></a>
##Demo Environment  

* Ubuntu 14.04 x86_64 (baseimage-docker)
* CDH 5.3.1
* clustered Data ONTAP 8.2.x or later 
  * Pre configuration on a single node cluster
  * 1 SVM , 2 LIFs , 2 Volumes

<a name="cont"></a>
##Setup Docker Container 

Dockerfile download
```
$ git clone https://github.com/tksarah/dockerfile.git
```

```
$ cd dockerfile/nfs-connector/test-20150305
```

Build a docker image
```
$ docker build -t hoge/fuga .
```
Run a container
```
$ docker run --rm -i -t --name demo -p 8088:8088 hoge/fuga /sbin/my_init -- bash -l
*** Running /etc/my_init.d/00_regen_ssh_host_keys.sh...
No SSH host key available. Generating one...
Creating SSH2 RSA key; this may take some time ...
Creating SSH2 DSA key; this may take some time ...
Creating SSH2 ECDSA key; this may take some time ...
Creating SSH2 ED25519 key; this may take some time ...
invoke-rc.d: policy-rc.d denied execution of restart.
*** Running /etc/rc.local...
*** Booting runit daemon...
*** Runit started as PID 94
*** Running bash -l...
root@6c89346c4859:/# starting nodemanager, logging to /var/log/hadoop-yarn/yarn-yarn-nodemanager-6c89346c4859.out
starting resourcemanager, logging to /var/log/hadoop-yarn/yarn-yarn-resourcemanager-6c89346c4859.out

root@6c89346c4859:/#

``` 

Verification 
```
root@6c89346c4859:/# su - testuser
testuser@6c89346c4859:~$ hadoop fs -ls /
15/03/14 04:29:11 INFO nfs.NFSv3FileSystem: User config file: /etc/hadoop/conf/nfs-users.json
15/03/14 04:29:11 INFO nfs.NFSv3FileSystem: Group config file: /etc/hadoop/conf/nfs-groups.json
Store with ep Endpoint: host=nfs://10.128.218.44:2049/ export=/htop path=/ has fsId 2147484677
Found 8 items
drwxrwxrwx   - root root       4096 2015-02-21 00:15 /.snapshot
drwxrwxrwx   - hdfs hdfs       4096 2015-03-14 03:46 /benchmarks
drwxrwxrwx   - root root       4096 2015-03-14 04:13 /hadoopvol1
drwxrwxrwx   - root root       4096 2015-03-14 04:06 /hadoopvol2
drwxrwxrwx   - hdfs hdfs       4096 2015-03-14 03:46 /hbase
drwxrwxrwx   - hdfs hdfs       4096 2015-03-14 03:46 /tmp
drwxrwxrwx   - hdfs hdfs       4096 2015-03-14 03:50 /user
drwxrwxrwx   - hdfs hdfs       4096 2015-03-14 03:47 /var

testuser@6c89346c4859:~$ hadoop fs -ls
15/03/14 04:29:20 INFO nfs.NFSv3FileSystem: User config file: /etc/hadoop/conf/nfs-users.json
15/03/14 04:29:20 INFO nfs.NFSv3FileSystem: Group config file: /etc/hadoop/conf/nfs-groups.json
Store with ep Endpoint: host=nfs://10.128.218.44:2049/ export=/htop path=/ has fsId 2147484677
testuser@6c89346c4859:~$
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
testuser@6c89346c4859:~$ exit
logout
root@6c89346c4859:/# exit
logout
Clean up test data directories.
15/03/14 04:35:14 INFO nfs.NFSv3FileSystem: User config file: /etc/hadoop/conf/nfs-users.json
15/03/14 04:35:14 INFO nfs.NFSv3FileSystem: Group config file: /etc/hadoop/conf/nfs-groups.json
Store with ep Endpoint: host=nfs://10.128.218.44:2049/ export=/htop path=/ has fsId 2147484677
15/03/14 04:35:16 INFO nfs.NFSv3FileSystem: User config file: /etc/hadoop/conf/nfs-users.json
15/03/14 04:35:16 INFO nfs.NFSv3FileSystem: Group config file: /etc/hadoop/conf/nfs-groups.json
Store with ep Endpoint: host=nfs://10.128.218.44:2049/ export=/htop path=/ has fsId 2147484677
15/03/14 04:35:18 INFO nfs.NFSv3FileSystem: User config file: /etc/hadoop/conf/nfs-users.json
15/03/14 04:35:18 INFO nfs.NFSv3FileSystem: Group config file: /etc/hadoop/conf/nfs-groups.json
Store with ep Endpoint: host=nfs://10.128.218.44:2049/ export=/htop path=/ has fsId 2147484677
15/03/14 04:35:20 INFO nfs.NFSv3FileSystem: User config file: /etc/hadoop/conf/nfs-users.json
15/03/14 04:35:20 INFO nfs.NFSv3FileSystem: Group config file: /etc/hadoop/conf/nfs-groups.json
Store with ep Endpoint: host=nfs://10.128.218.44:2049/ export=/htop path=/ has fsId 2147484677
15/03/14 04:35:22 INFO nfs.NFSv3FileSystem: User config file: /etc/hadoop/conf/nfs-users.json
15/03/14 04:35:22 INFO nfs.NFSv3FileSystem: Group config file: /etc/hadoop/conf/nfs-groups.json
Store with ep Endpoint: host=nfs://10.128.218.44:2049/ export=/htop path=/ has fsId 2147484677
Clean up complete.
*** bash exited with status 0.
*** Shutting down runit daemon (PID 94)...
*** Killing all processes...


Session terminated, terminating shell...Session terminated, terminating shell... ...terminated.
 ...terminated.
$
```
****

Access on Browser 

* Hadoop
 * http://*your docker host ip address*:8088/

<a name="test"></a>
##Test Job

```
$ hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 2 100
```
