FROM nimlang/nim
RUN apt-get update -y && apt-get install -y gcc-avr avr-libc make
WORKDIR /root/devel
