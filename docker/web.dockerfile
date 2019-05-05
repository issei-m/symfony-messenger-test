FROM nginx:1.16.0-alpine

RUN { \
    echo 'server {'; \
    echo '  server_name domain.tld www.domain.tld;'; \
    echo '  root /var/www/html/public;'; \
    echo '  location / {'; \
    echo '      try_files $uri /index.php$is_args$args;'; \
    echo '  }'; \
    echo '  location ~ ^/index\.php(/|$) {'; \
    echo '      fastcgi_pass app:9000;'; \
    echo '      fastcgi_split_path_info ^(.+\.php)(/.*)$;'; \
    echo '      include fastcgi_params;'; \
    echo '      fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;'; \
    echo '      fastcgi_param DOCUMENT_ROOT $realpath_root;'; \
    echo '      fastcgi_read_timeout 86400s;'; \
    echo '      internal;'; \
    echo '  }'; \
    echo '  location ~ \.php$ {'; \
    echo '      return 404;'; \
    echo '  }'; \
    echo '}'; \
} > /etc/nginx/conf.d/app.conf
