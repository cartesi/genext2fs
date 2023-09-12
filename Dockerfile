FROM debian:bookworm-20230725 as xgenext2fs-builder
ARG GENEXT2FS_VERSION=1.5.2
ARG TARGETARCH
ARG DESTDIR=release

WORKDIR /usr/src/genext2fs
RUN apt update \
&&  apt install -y --no-install-recommends \
      automake \
      autotools-dev \
      build-essential \
      curl ca-certificates \
      libarchive-dev
COPY . .
RUN ./autogen.sh \
&&  ./configure --enable-libarchive --prefix=/usr \
&&  make install DESTDIR=${DESTDIR} \
&&  mkdir -p ${DESTDIR}/DEBIAN \
&&  cat tools/templates/control.template | sed "s|ARG_VERSION|${GENEXT2FS_VERSION}|g;s|ARG_ARCH|${TARGETARCH}|g" > ${DESTDIR}/DEBIAN/control \
&& dpkg-deb -Zxz --root-owner-group --build ${DESTDIR} xgenext2fs.deb
