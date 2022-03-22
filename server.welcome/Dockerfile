FROM server.builder

ENV PATH /home/openttd/data:$PATH
ENV OPENTTD_VERSION 12.1

USER openttd

WORKDIR /home/openttd/conf.w

COPY . .

CMD [ "/home/openttd/data/openttd", "-D", "-g", "!!!" ]