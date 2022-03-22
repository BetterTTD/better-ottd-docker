FROM server.builder

ENV PATH /home/openttd/:$PATH
ENV OPENTTD_VERSION 12.1

RUN apk update && \
    apk add --no-cache \
    lzo \
    freetype \
    icu-libs \
    zlib && \
    chown -R openttd.van:openttd.van /home/openttd/conf.vanilla
    
WORKDIR /home/openttd/conf.vanilla

COPY . .

VOLUME . vanilla

USER openttd.van

CMD [ "openttd", "-D" ]