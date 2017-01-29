# create several R versions on centos 6.6
FROM centos:6.6

ENV RINST=/opt/R
ENV PATH=$RINST/bin:$PATH \
    LD_LIBRARY_PATH=$RINST/lib:$LD_LIBRARY_PATH \
    CFLAGS="-I$RINST/include" \
    LDFLAGS="-L$RINST/lib"

RUN yum -y install yum-utils epel-release tar bzip2 cairo-devel readline-devel \
    libicu-devel libXt-devel openssl-devel \
    java-1.8.0-openjdk-devel centos-release-scl && mkdir -p $RINST/extra
COPY extra $RINST/extra
RUN yum install -y devtoolset-6 && source scl_source enable devtoolset-6 \
   && curl -L https://github.com/xianyi/OpenBLAS/archive/v0.2.19.tar.gz | tar xz \
   && cd OpenBLAS-0.2.19 && make && make PREFIX=/usr/local install
RUN source scl_source enable devtoolset-6 && cd $RINST/extra && tar xzf bzip2-1.0.6.tar.gz \
   && tar xzf zlib-1.2.8.tar.gz && tar xjf curl-7.48.0.tar.bz2 \
   && tar xjf pcre-8.38.tar.bz2 && tar xjf xz-5.2.2.tar.bz2 \
   && tar xzf R-3.3.2.tar.gz \
   && cd pcre-8.38 && ./configure --enable-utf8 --prefix=$RINST &&\
      make && make install \
   && cd ../curl-7.48.0 && ./configure --prefix=$RINST && make && make install \
   && cd ../xz-5.2.2 && ./configure --prefix=$RINST && make && make install \
   && cd ../bzip2-1.0.6 && make -f Makefile-libbz2_so && make clean && \
      make -n install PREFIX=$RINST && make install PREFIX=$RINST \
   && cd ../zlib-1.2.8 && ./configure --prefix=$RINST && make && make install \
# preparations for R compilation completed
   && cd ../R-3.3.2 && ./configure --prefix=$RINST/R-3.3.2 && make && make install

