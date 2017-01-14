# create several R versions on centos 6.6
FROM centos:6.6

MAINTAINER Reinhold Koch <https://github.com/reikoch/Renv>
RUN yum -y install yum-utils epel-release tar
RUN yum -y install R && yum-builddep -y R && mkdir -p /opt/R/R-3.1.2 /opt/R/R-3.0.2 /tmp/Renv
RUN cd /tmp/Renv && curl -O https://cloud.r-project.org/src/base/R-3/R-3.1.2.tar.gz && tar xzf R-3.1.2.tar.gz
RUN cd /tmp/Renv/R-3.1.2 && ./configure --prefix=/opt/R/R-3.1.2 --enable-R-shlib && make && make install
RUN cd /tmp/Renv && curl -O https://cloud.r-project.org/src/base/R-3/R-3.0.2.tar.gz && tar xzf R-3.0.2.tar.gz
RUN cd /tmp/Renv/R-3.0.2 && ./configure --prefix=/opt/R/R-3.0.2 --enable-R-shlib && make && make install
