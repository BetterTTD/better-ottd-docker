FROM alpine AS builder

RUN mkdir -p /data \
    && mkdir /tmp/src
    
ENV OPENGFX_VERSION 7.1
ENV OPENTTD_VERSION 12.1

WORKDIR /

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
    -DGLOBAL_DIR=/data \
    -DPERSONAL_DIR=/ \
    -DCMAKE_BINARY_DIR=bin \
    -DCMAKE_INSTALL_PREFIX=/data \
    ../src \
    && make CMAKE_BUILD_TYPE=release -j"$(nproc)" \
    && make install \
    && cd /data/baseset \
    && rm -rf /tmp/src* \
    && wget -q https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip \
    && unzip opengfx-${OPENGFX_VERSION}-all.zip \
    && tar -xf opengfx-${OPENGFX_VERSION}.tar \
    && rm -rf opengfx-*.tar opengfx-*.zip \
    && cd /home \
    && apk del .buildreqs
###
###
###

FROM alpine

ENV OPENTTD_VERSION 12.1
LABEL org.label-schema.name="OpenTTD" \
      org.label-schema.description="Lightweight OpenTTD Build" \
      org.label-schema.url="https://github.com/same-f/tg-ottd-docker" \
      org.label-schema.vcs-url="https://github.com/openttd/openttd" \
      org.label-schema.vendor="TeamGame_OpenTTD" \
      org.label-schema.version=$OPENTTD_VERSION \
      org.label-schema.schema-version="1.0"
MAINTAINER tgsamef <tg.same.f@gmail.com>

RUN apk update && \
    apk add --no-cache \
    lzo \
    freetype \
    icu-libs \
    zlib

RUN adduser -D -h /home/welcome -s /bin/false openttd && \
    chown -R openttd /home/welcome

WORKDIR /home/welcome

COPY --from=builder /data /home/welcome

COPY . .

USER openttd

VOLUME /home/welcome
VOLUME [ "../.newgrf" "newgrf"]

EXPOSE 3979/tcp
EXPOSE 3979/udp

EXPOSE 3972/tcp

CMD [ "./openttd", "-D", "-c", "openttd.cfg", "-g", "save/WS-F4-start.sav" ]