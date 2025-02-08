FROM registry.astralinux.ru/astra/ubi18:latest AS build-env
WORKDIR /
ADD http://deb.debian.org/debian/pool/main/g/golang-1.23/golang-1.23_1.23.2-1.dsc /
ADD http://deb.debian.org/debian/pool/main/g/golang-1.23/golang-1.23_1.23.2.orig.tar.gz /
ADD http://deb.debian.org/debian/pool/main/g/golang-1.23/golang-1.23_1.23.2.orig.tar.gz.asc /
ADD http://deb.debian.org/debian/pool/main/g/golang-1.23/golang-1.23_1.23.2-1.debian.tar.xz /
ADD http://deb.debian.org/debian/pool/main/g/golang-defaults/golang-defaults_1.23~2.dsc /
ADD http://deb.debian.org/debian/pool/main/g/golang-defaults/golang-defaults_1.23~2.tar.xz /
RUN  apt update 
RUN  apt install -y dpkg-dev debhelper-compat golang-go netbase debhelper-compat dh-exec
RUN dpkg-source -x golang-1.23_1.23.2-1.dsc
RUN cd golang-1.23-1.23.2  && DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage
RUN cd /
RUN dpkg-source -x golang-defaults_1.23~2.dsc
RUN cd golang-defaults-1.23~2 && dpkg-buildpackage
FROM registry.astralinux.ru/astra/ubi18:latest
COPY --from=build-env /golang-go_1.23~2_amd64.deb /
COPY --from=build-env /golang-any_1.23~2_amd64.deb /
COPY --from=build-env /gccgo-go_1.23~2_amd64.deb /
COPY --from=build-env /golang-src_1.23~2_all.deb /
COPY --from=build-env /golang-doc_1.23~2_all.deb /
COPY --from=build-env /golang_1.23~2_amd64.deb /
COPY --from=build-env /golang-1.23-doc_1.23.2-1_all.deb /
COPY --from=build-env /golang-1.23-go_1.23.2-1_amd64.deb /
COPY --from=build-env /golang-1.23-src_1.23.2-1_all.deb /
COPY --from=build-env /golang-1.23_1.23.2-1_all.deb /

RUN apt install -y ./golang-1.23-doc_1.23.2-1_all.deb \
./golang-1.23-go_1.23.2-1_amd64.deb \
./golang-1.23-src_1.23.2-1_all.deb \
./golang-1.23_1.23.2-1_all.deb \
./golang-go_1.23~2_amd64.deb \
./golang-any_1.23~2_amd64.deb \
#./gccgo-go_1.23~2_amd64.deb \
./golang-src_1.23~2_all.deb \
./golang-doc_1.23~2_all.deb \
./golang_1.23~2_amd64.deb
MAINTAINER kazan417 <kazan417@mail.ru>
