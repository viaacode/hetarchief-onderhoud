FROM nginxinc/nginx-unprivileged
USER root
RUN apt-get update && apt-get -y install curl &&\
 curl https://raw.githubusercontent.com/viaacode/hetarchief-client/master/src/maintenance-page/index.html > /usr/share/nginx/html/maintenance.html &&\
 curl https://raw.githubusercontent.com/viaacode/hetarchief-client/release/v0.16.0/src/maintenance-page/outage.html > /usr/share/nginx/html/error.html &&\
 apt-get -y purge curl
COPY nginx/maintenance.txt /usr/share/nginx/html/.maintenance
COPY nginx/health.html /usr/share/nginx/html/health/healthz.html
COPY --chown=101:101 docker-entrypoint /docker-entrypoint
RUN chmod +x /docker-entrypoint &&\
  chown 101:101  -R /usr/share/nginx/html/
## set this to some value to show MAINTENANCE , if not set render error page
#ENV MAINTENANCE true
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
WORKDIR /usr/share/nginx/html
RUN chgrp -R 0 /usr/share/nginx/html && chmod -R g+rwx /usr/share/nginx/html
USER nginx
ENTRYPOINT /docker-entrypoint
