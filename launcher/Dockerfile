FROM builder

WORKDIR /home/openttd/run

COPY . .

RUN apk add --no-cache \
    lzo \
    freetype \
    icu-libs \
    zlib && \
    echo "rcon_password = ${RCON_PASSWORD}" > secrets.cfg && \
    echo "admin_password = ${ADMIN_PASSWORD}" >> secrets.cfg && \
    echo "client_name = ${CLIENT_NAME}" > private.cfg && \
    echo "server_name = ${SERVER_NAME}" >> private.cfg

USER openttd

EXPOSE 3979:3979/tcp
EXPOSE 3979:3979/udp

CMD [ "openttd", "-D" ]