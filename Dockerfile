FROM alpine:3.16.2
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
