# NetApp NFS Connector with CDH 5.3.1
#
# VERSION               0.0.1

FROM tksarah/cdh_pseudo:1.0
MAINTAINER Takeshi.K <sarah@fm.secret.jp>

ADD hadoop-*.conf /usr/local/monit/conf/ \
    nfs-mapping.json /etc/hadoop/conf/ \
    core-site.xml /etc/hadoop/conf/ \
    hadoop-nfs-connector-1.0.4.jar /usr/lib/hadoop/lib/

RUN mv /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/org.core-site.xml \
    chmod 755 /etc/hadoop/conf/core-site.xml \
    echo "export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce" >> /root/.bashrc

CMD ["/usr/local/bin/monit","-I","-c","/usr/local/monit/conf/monitrc"]

