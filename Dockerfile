FROM centos:centos7
MAINTAINER Francois Jehl <francoisjehl@gmail.com>

ENV CLICKHOUSE_CONFIG=/etc/clickhouse-server/config.xml \
    NODE_TYPE=master \
    SHARD=1

RUN yum install -y \
      pygpgme \
      yum-util \
      python-setuptools \
      make \
      gcc-c++ \
      gettext

# Generate some TPCH data
COPY tpch /opt/tpch
RUN cd /opt/tpch/ssb-dbgen && \
    make >/dev/null 2>&1 && \
    ./dbgen -q -T p && \
    ./dbgen -q -T c && \
    ./dbgen -q -T l && \
    mv *.tbl ../data && \
    cd /

# Install Clickhouse
COPY altinity_clickhouse.repo /etc/yum.repos.d/
RUN yum -q makecache -y --disablerepo='*' --enablerepo='altinity_clickhouse' && \
    yum install -y \
      clickhouse-server \
      clickhouse-client
COPY config.xml /etc/clickhouse-server/
COPY config.d/ /etc/clickhouse-server/config.d/

# SupervisorD configuration
RUN easy_install supervisor
COPY clickhouse-server.sv.conf samples_deployer.sv.conf /etc/supervisor/conf.d/
COPY supervisord.conf /etc/supervisord.conf
COPY clickhouse-server samples_deployer /usr/local/bin/

# Make sure clickhouse owns the whole folder
RUN chown -R clickhouse:clickhouse /etc/clickhouse-server/

EXPOSE 9000 8123 9009
CMD ["/usr/bin/supervisord", "-n"]
