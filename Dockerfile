FROM alpine

RUN apk add curl jq

COPY ./check.sh /usr/local/

ENTRYPOINT ["/usr/local/check.sh"]
