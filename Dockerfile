FROM alpine AS builder

RUN mkdir -p /home/openttd/data/baseset \
    && mkdir /tmp/src
    
ENV OPENGFX_VERSION 7.1
ENV OPENTTD_VERSION 12.1

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
    -DGLOBAL_DIR=/home/openttd/data \
    -DPERSONAL_DIR=/home/openttd \
    -DCMAKE_BINARY_DIR=bin \
    -DCMAKE_INSTALL_PREFIX=/home/openttd/data \
    ../src \
    && make CMAKE_BUILD_TYPE=release -j"$(nproc)" \
    && make install \
    && cd /home/openttd/data/baseset \
    && rm -rf /tmp/src* \
    && wget -q https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip \
    && unzip opengfx-${OPENGFX_VERSION}-all.zip \
    && tar -xf opengfx-${OPENGFX_VERSION}.tar \
    && rm -rf opengfx-*.tar opengfx-*.zip \
    && cd /home/openttd \
    && apk del .buildreqs

###
###

FROM alpine AS vanilla
ENV PATH /home/openttd/:$PATH
ENV OPENTTD_VERSION 12.1
LABEL org.label-schema.name="OpenTTD" \
      org.label-schema.description="Lightweight OpenTTD Build" \
      org.label-schema.url="https://github.com/same-f/tg-ottd-docker" \
      org.label-schema.vcs-url="https://github.com/openttd/openttd" \
      org.label-schema.vendor="TeamGame_OpenTTD" \
      org.label-schema.version=$OPENTTD_VERSION \
      org.label-schema.schema-version="1.0"
AUTHOr tgsamef <tg.same.f@gmail.com>

RUN mkdir -p /home/openttd/{conf.vanilla,conf.welcome,conf.public} && \
    useradd -d /home/opentt/conf.vanilla -s /bin/false openttd.van && \
    useradd -d /home/opentt/conf.welcome -s /bin/false openttd.wel && \
    useradd -d /home/opentt/conf.public -s /bin/false openttd.pub && \
    apk update && \
    apk add --no-cache \
    lzo \
    freetype \
    icu-libs \
    zlib \
    liblzma

WORKDIR /home/openttd

COPY --from=builder /home/openttd/data /home/openttd/data

USER openttd

CMD [ "sleep", "9999" ]