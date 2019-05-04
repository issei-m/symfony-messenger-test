FROM nginx:1.16.0-alpine

COPY docker/nginx_app.conf /etc/nginx/conf.d/app.conf
