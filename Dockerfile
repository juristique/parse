FROM debian:testing
MAINTAINER Alban Linard <alban@linard.fr>

ADD . /src/penalyzer
RUN luarocks install luasec OPENSSL_LIBDIR="/lib/x86_64-linux-gnu/"
RUN cd /src/penalyzer/ && \
    luarocks make rockspec/juristique-penalyzer-master-1.rockspec && \
    cd /
RUN rm -rf /src/penalyzer
ENTRYPOINT ["penalyzer"]
CMD ["--help"]
