FROM index.alauda.cn/rongchang/ruby_base

RUN apt-get update && apt-get install -y \
	wget \
	libcurl4-gnutls-dev  \
	libluajit-5.1-dev

RUN cd /tmp && \
	wget https://openresty.org/download/ngx_openresty-1.7.7.2.tar.gz && \
	tar -zxvf ngx_openresty-1.7.7.2.tar.gz && \
	cd ngx_openresty-1.7.7.2 && \
	./configure --prefix=/opt/nginx --with-luajit && \
	make && make install && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /data/router/current/

COPY docker/nginx.conf /opt/nginx/nginx/conf/nginx.conf

ENTRYPOINT ["/data/router/current/docker/entrypoint.sh"]

EXPOSE  80 12121

CMD ["/opt/nginx/nginx/sbin/nginx"]
