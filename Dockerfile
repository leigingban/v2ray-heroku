FROM scratch
ADD alpine-minirootfs-3.12.0-x86_64.tar.gz /

RUN apk add --no-cache --virtual .build-deps ca-certificates curl unzip tor

ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
CMD /configure.sh
