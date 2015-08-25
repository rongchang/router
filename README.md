前提条件：
参考这里下载并安装 openresty
http://openresty.org/cn/

大致安装方法：
在依赖安装完成以后

    tar xzvf ngx_openresty-VERSION.tar.gz
    cd ngx_openresty-VERSION/

    （注意下面的配置：）
    (ubuntu)./configure --prefix=/opt/nginx \
            --with-luajit \
    (mac)./configure  --with-cc-opt="-I/usr/local/Cellar/pcre/8.36/include" --with-ld-opt="-L/usr/local/Cellar/pcre/8.36/lib" --with-luajit        
    make
    make install


然后用根目录下的 nginx.conf 替换 /opt/nginx/ngxin/conf 下的同名文件，并且配置项目相关的路径
如果你也使用 /opt/nginx 作为ngxin的默认目录，只需要更改下列路径为你的项目路径

这条配置的最后一个路径：

    lua_package_path '/opt/nginx/lualib/?.lua;/opt/nginx/lualib/?/init.lua;./?.lua;/opt/nginx/luajit/share/luajit-2.1.0-alpha/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/opt/nginx/luajit/share/lua/5.1/?.lua;/opt/nginx/luajit/share/lua/5.1/?/init.lua;/data/router/current/router_lua/?.lua;';

和这两个路径：

    const:set("path", "/data/router/current/")
    include /data/router/current/router_core/*.conf;


    create table model_paths
    (
        `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `model_name` varchar(255) NOT NULL,
        `server_name` varchar(255) NOT NULL,
        `host` varchar(255) NOT NULL DEFAULT '',
        `path` varchar(255) NOT NULL,
        `created_at` datetime DEFAULT NULL,
        `updated_at` datetime DEFAULT NULL,
        PRIMARY KEY (`id`),
        UNIQUE KEY `model_name` (`model_name`)
    )

