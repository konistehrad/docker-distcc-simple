FROM ubuntu:groovy
MAINTAINER Conrad Kreyling "conrad@kreyling.biz"
LABEL description="Stable compiler collection with distcc for internal use"

ENV JOBS 8
ENV NICE 10
ENV USER nobody
ENV LOG_LEVEL info

RUN \
  echo "** updating and installing packages **" && \
  apt update && \
  apt install -y \
     gcc \
     g++ \
     gcc-aarch64-linux-gnu \
     g++-aarch64-linux-gnu \
     gcc-arm-linux-gnueabihf \
     g++-arm-linux-gnueabihf \
     clang \
     distcc && \
  update-distcc-symlinks && \
  echo "**** clean up ****" && \
  apt-get autoclean && \
  rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

EXPOSE 3632
EXPOSE 3633

ENTRYPOINT distccd --daemon --no-detach --log-stderr --log-level=$LOG_LEVEL --user $USER -N $NICE -j $JOBS --allow 0.0.0.0/0 --listen 0.0.0.0 --stats --stats-port 3633 --port 3632
