# NetApp NFS Connector with CDH 5.3.1
#
# VERSION               0.0.1

FROM tksarah/cdh_pseudo:1.0
MAINTAINER Takeshi.K <sarah@fm.secret.jp>

ADD nfs-mapping.json /etc/hadoop/conf/ 
ADD core-site.xml /etc/hadoop/conf/ 
ADD hadoop-nfs-connector-1.0.4.jar /usr/lib/hadoop/lib/
ADD hadoop-*.conf /usr/local/monit/conf/

RUN mv /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/org.core-site.xml
RUN chmod 755 /etc/hadoop/conf/core-site.xml
RUN echo "export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce" >> /root/.bashrc

CMD ["/usr/local/bin/monit","-I","-c","/usr/local/monit/conf/monitrc"]

