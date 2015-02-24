# NetApp NFS Connector with CDH 5.3.1
#
# VERSION               0.0.1

FROM tksarah/cdh_pseudo:latest
MAINTAINER Takeshi.K <sarah@fm.secret.jp>

ADD hadoop-*.conf /usr/local/monit/conf/
ADD nfs-mapping.json /etc/hadoop/conf/
RUN mv /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/org.core-site.xml
ADD core-site.xml /etc/hadoop/conf/
RUN chmod 755 /etc/hadoop/conf/core-site.xml

CMD ["/usr/local/bin/monit","-I","-c","/usr/local/monit/conf/monitrc"]

