FROM alpine

RUN mkdir -p /home/openttd/run/baseset \
    && mkdir /tmp/src \
    && adduser -D -h /home/openttd -s /bin/false openttd \
    && chown -R openttd:openttd /home/openttd

WORKDIR /home/openttd

RUN apk update && \
    apk add --no-cache --virtual=.buildreqs \
    alpine-sdk \
    wget \
    ca-certificates \
    lzo-dev \
    freetype-dev \
    gcc \
    git \
    make \
    cmake \
    patch \
    zlib-dev \
    && cd /tmp/src \
    && git clone --verbose --progress https://github.com/OpenTTD/OpenTTD.git . \
    && git fetch --tags \
    && git checkout ${OPENTTD_VERSION} \
    && mkdir /tmp/build && cd /tmp/build \
    && cmake --log-level=VERBOSE \
    -DOPTION_DEDICATED=ON \
    -DOPTION_INSTALL_FHS=OFF \
    -DCMAKE_BUILD_TYPE=release \
    -DGLOBAL_DIR=/home/openttd/run \
    -DPERSONAL_DIR=/home/openttd \
    -DCMAKE_BINARY_DIR=bin \
    -DCMAKE_INSTALL_PREFIX=/home/openttd/run \
    ../src \
    && make CMAKE_BUILD_TYPE=release -j"$(nproc)" \
    && make install \
    && cd /home/openttd/run/baseset \
    && rm -rf /tmp/src* \
    && wget -q https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip \
    && unzip opengfx-${OPENGFX_VERSION}-all.zip \
    && tar -xf opengfx-${OPENGFX_VERSION}.tar \
    && rm -rf opengfx-*.tar opengfx-*.zip \
    && cd /home/openttd \
    && apk del .buildreqs
    
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