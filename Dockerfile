FROM index.alauda.cn/rongchang/router_base

ADD . /data/router/current/

COPY nginx.conf /opt/nginx/nginx/conf/nginx.conf

RUN mkdir /data/log && \
    mkdir /data/nginx && \
    mkdir /data/nginx/pid
    # touch /data/nginx/pid/nginx.pid

ENTRYPOINT ["/data/router/current/docker/entrypoint.sh"]

EXPOSE  80 12121

CMD ["/opt/nginx/nginx/sbin/nginx"]
