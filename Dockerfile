FROM ubuntu:16.04

ENV LUA FRONTEND


RUN apt update && apt install git \
				wget \
				make \
				gcc \
				libpcre++-dev \
				zlib1g-dev \
				libxslt-dev \
				libperl-dev \
				libpcre3 \
				libpcre3-dev \
				build-essential \
				libssl-dev \
				libgd2-xpm-dev\ 
				libgeoip-dev\
				openssl -y \

    && wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz -P /opt \
    && wget https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz -P /opt \

    && tar -xzvf /opt/LuaJIT-2.0.5.tar.gz -C /opt \
    && tar -xzvf /opt/v0.3.0.tar.gz -C /opt \

    && cd /opt/LuaJIT-2.0.5/ \
    && make install \
    && export LUAJIT_LIB=/usr/local/lib \
    && export LUAJIT_INC=/usr/local/include/luajit-2.0 \

    && tar -xzvf /opt/v0.3.0.tar.gz \
    && mkdir /var/www/ && git -C /var/www/ clone https://github.com/openresty/lua-nginx-module.git  \
    && wget 'http://nginx.org/download/nginx-1.13.6.tar.gz' -P /opt \
    && tar -xzvf /opt/nginx-1.13.6.tar.gz -C /opt \
    && cd /opt/nginx-1.13.6/ \

    && ./configure --prefix=/opt/nginx-1.13.6 \
         --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
         --prefix=/etc/nginx \
         --sbin-path=/usr/sbin/nginx \
         --conf-path=/etc/nginx/nginx.conf \
         --error-log-path=/var/log/nginx/error.log \
         --http-log-path=/var/log/nginx/access.log \
         --lock-path=/var/lock/nginx.lock \
         --pid-path=/var/run/nginx.pid \
         --http-client-body-temp-path=/etc/nginx/body \
         --http-fastcgi-temp-path=/etc/nginx/fastcgi \
         --http-proxy-temp-path=/etc/nginx/proxy \
         --http-scgi-temp-path=/etc/nginx/scgi \
         --http-uwsgi-temp-path=/etc/nginx/uwsgi \
         --user=nginx \
         --group=nginx \
         --with-debug \
         --with-file-aio \
         --with-mail \
         --with-mail_ssl_module \
         --with-threads \
         --with-select_module \
         --with-stream \
         --with-stream_ssl_module \
         --with-http_addition_module \
         --with-http_auth_request_module \
         --with-http_dav_module \
         --with-http_flv_module \
         --with-http_geoip_module \
         --with-http_gunzip_module \
         --with-http_gzip_static_module \
         --with-http_image_filter_module \
         --with-http_mp4_module \
         --with-http_perl_module \
         --with-http_random_index_module \
         --with-http_realip_module \
         --with-http_secure_link_module \
         --with-http_stub_status_module \
         --with-http_sub_module \
         --with-http_ssl_module \
         --with-http_v2_module \
         --with-http_xslt_module \
         --with-poll_module \
         --with-openssl-opt=enable-tls1_3 \
         --add-module=/opt/ngx_devel_kit-0.3.0 \
         --add-module=/var/www/lua-nginx-module \ 

    && make  \
    && make install 


ADD nginx.conf /etc/nginx/nginx.conf

RUN  cat /etc/nginx/nginx.conf

VOLUME ["/var/www"]

EXPOSE 80 

CMD ["nginx", "-g", "daemon off;"]





