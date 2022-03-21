

COPY /data/* /home/openttd/run/

EXPOSE 3979:3979/tcp
EXPOSE 3979:3979/udp

RUN apk add --no-cache \
    lzo \
    freetype \
    icu-libs \
    zlib

USER openttd

CMD [ "openttd", "-D" ]
