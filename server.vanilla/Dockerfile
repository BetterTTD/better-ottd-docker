FROM server.builder

ENV PATH /home/openttd/data:$PATH
ENV OPENTTD_VERSION 12.1
  
WORKDIR /home/openttd

RUN mkdir /home/openttd/conf.vanilla \
    && /home/openttd/conf.vanilla

COPY . .

USER openttd

CMD [ "/home/openttd/data/openttd", "-D" ]