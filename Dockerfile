FROM alpine:3.16.2 as testing
RUN \
  apk add \
    bash~=5 \
    shellcheck~=0 \
    shfmt~=3 \
    cppcheck~=2 \
    clang-extra-tools~=13 \
    make~=4 \
    gcc~=11 \
    musl-dev~=1 \
    git~=2 \
    cmake~=3 \
    valgrind~=3 \
    gcovr~=5 \
    py3-pip~=22
RUN pip install \
  cmakelang==0.* \
  mdformat==0.*
ARG USAGEF_WORKDIR_PATH
RUN git config --global --add safe.directory $USAGEF_WORKDIR_PATH
WORKDIR $USAGEF_WORKDIR_PATH

FROM liushuyu/osxcross@sha256:fa32af4677e2860a1c5950bc8c360f309e2a87e2ddfed27b642fddf7a6093b76 as packaging
RUN \
  apt update && \
  apt install -y \
    mingw-w64=7.* \
    gcc-aarch64-linux-gnu=4:9.* \
    gcc-arm-linux-gnueabi=4:9.* \
    binutils-arm-linux-gnueabi=2.* && \
  apt remove -y cmake && \
  wget \
    https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-Linux-x86_64.sh \
    -q -O /tmp/cmake-install.sh && \
  chmod u+x /tmp/cmake-install.sh && \
  mkdir /opt/cmake-3.24.1 && \
  /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-3.24.1 && \
  rm /tmp/cmake-install.sh && \
  ln -s /opt/cmake-3.24.1/bin/* /usr/local/bin
ARG USAGEF_WORKDIR_PATH
WORKDIR $USAGEF_WORKDIR_PATH
