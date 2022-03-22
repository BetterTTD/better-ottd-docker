FROM builder

WORKDIR /home/openttd/run

ENV RCON_PASSWORD r_pass
ENV ADMIN_PASSWORD a_pass
ENV CLIENT_NAME vanilla
ENV SERVER_NAME "TG Vanilla (Reddit legacy)"

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