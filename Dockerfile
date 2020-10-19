FROM alpine
RUN apk update && apk add --no-cache ca-certificates curl unzip

ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
CMD /configure.sh
