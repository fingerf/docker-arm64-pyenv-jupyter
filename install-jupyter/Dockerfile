FROM debian:11

ADD package /root/

RUN /root/install.sh ; rm -rfv /root/install.sh

CMD run_jupyter
