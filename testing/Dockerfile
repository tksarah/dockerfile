# NetApp NFS Connector with CDH 5.3.1 on Ubuntu 14.04
#
# VERSION               1.0.0

FROM tksarah/cdh_nfs_connector:latest
MAINTAINER Takeshi.K <sarah@fm.secret.jp>

# my_init Setting
RUN  mkdir -p /etc/service/hadoop-yarn-resourcemanager && \
     mkdir -p /etc/service/hadoop-yarn-nodemanager
COPY r-run /etc/service/hadoop-yarn-resourcemanager/run
COPY n-run /etc/service/hadoop-yarn-nodemanager/run
RUN  chmod 755 /etc/service/hadoop-yarn-resourcemanager/run && \
     chmod 755 /etc/service/hadoop-yarn-nodemanager/run
RUN  mv /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh /usr/lib/hadoop-yarn/sbin/org.yarn-daemon.sh
COPY yarn-daemon.sh /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh

# NFS Connector Setting
COPY nfs-mapping.json /etc/hadoop/conf/
RUN  mv /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/org.core-site.xml
COPY core-site.xml /etc/hadoop/conf/
RUN  chmod 755 /etc/hadoop/conf/core-site.xml
COPY hadoop-nfs-connector-1.0.4.jar /usr/lib/hadoop/lib/

CMD ["/sbin/my_init"]
