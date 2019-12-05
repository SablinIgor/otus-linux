FROM alpine:3.10

RUN apk update  && apk add nginx && mkdir -p /run/nginx

COPY ./default.conf /etc/nginx/conf.d/
COPY ./index.html /var/lib/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
