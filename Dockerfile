FROM nimlang/nim
RUN apt-get update -y && apt-get install -y gcc-avr avr-libc make
RUN useradd user && cp -r /etc/skel /home/user && chown -R user:user /home/user
WORKDIR /home/user/project
USER user
