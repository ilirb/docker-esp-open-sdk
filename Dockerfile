FROM ubuntu as esp

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y make unrar-free autoconf automake libtool gcc g++ gperf \
    flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python python-serial \
    sed git unzip bash help2man wget bzip2 libtool-bin && \
    apt-get autoremove -y

RUN groupadd -g 999 user && \
    useradd -r -u 999 -g user user && \
    mkdir -p /workdir && \
    chown -R user.user /workdir

USER user

WORKDIR /workdir

RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk.git

WORKDIR /workdir/esp-open-sdk

RUN make STANDALONE=y

FROM ubuntu

COPY --from=esp /workdir/esp-open-sdk/xtensa-lx106-elf/bin/ /esp-open-sdk

RUN export PATH=$PATH:/esp-open-sdk
