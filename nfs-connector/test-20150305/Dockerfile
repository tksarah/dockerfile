# NetApp NFS Connector with CDH 5.3.1 on Ubuntu 14.04
#
# VERSION               2.0.0 test

FROM tksarah/cdh_nfs_connector:latest
MAINTAINER Takeshi.K <sarah@fm.secret.jp>

# my_init Setting
COPY add_logf4.txt /tmp/
RUN  mkdir -p /etc/service/hadoop-yarn-resourcemanager && \
     mkdir -p /etc/service/hadoop-yarn-nodemanager && \
     mv /etc/service/syslog-ng /root && \
     mv /etc/service/syslog-forwarder /root && \
     mv /etc/service/cron /root && \
     mv /etc/service/sshd /root && \
     cat /tmp/add_logf4.txt >> /etc/hadoop/conf/log4j.properties
COPY r-run /etc/service/hadoop-yarn-resourcemanager/run
COPY n-run /etc/service/hadoop-yarn-nodemanager/run
RUN  chmod 755 /etc/service/hadoop-yarn-resourcemanager/run && \
     chmod 755 /etc/service/hadoop-yarn-nodemanager/run
RUN  mv /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh /usr/lib/hadoop-yarn/sbin/org.yarn-daemon.sh
COPY yarn-daemon.sh /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh

# NFS Connector Setting
COPY nfs-mapping.json /etc/hadoop/conf/
COPY nfs-users.json /etc/hadoop/conf/
COPY nfs-groups.json /etc/hadoop/conf/
RUN  groupadd -g 501 testuser && \
     groupadd -g 502 hoge && \
     useradd -m -u 501 testuser -g 501 && \
     useradd -m -u 502 hoge -g 502 && \
     mv /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/org.core-site.xml
COPY core-site.xml /etc/hadoop/conf/
RUN  chmod 755 /etc/hadoop/conf/core-site.xml && \
     chown root.hadoop /etc/hadoop/conf/*

# Copy Module
#COPY hadoop-nfs-connector-1.0.4.jar /usr/lib/hadoop/lib/
COPY hadoop-nfs-connector-2.0.0-SNAPSHOT.jar /usr/lib/hadoop/lib/

# Clean up
COPY .bash_logout /root/

CMD ["/sbin/my_init"]
