FROM index.alauda.cn/shaomq/ubuntu:14.04

RUN apt-get update && apt-get install -y \
	wget \
	libpcre3  \
	libpcre3-dev \
	libcurl4-gnutls-dev  \
	libluajit-5.1-dev \
	build-essential \
	libssl-dev
RUN cd /tmp && \
	wget https://openresty.org/download/ngx_openresty-1.7.7.2.tar.gz && \
	tar -zxvf ngx_openresty-1.7.7.2.tar.gz && \
	cd ngx_openresty-1.7.7.2 && \
	./configure --prefix=/opt/nginx --with-luajit && \
	make && make install

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /data/router/current/
COPY  docker/nginx.conf /opt/nginx/nginx/conf/nginx.conf

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE  80
EXPOSE  12121
CMD ["/opt/nginx/nginx/sbin/nginx"]
